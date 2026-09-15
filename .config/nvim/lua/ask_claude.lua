-- :Ask — ask Claude Code about the selected lines, in the context of the repo.
--
--   :Ask [question]      fresh session (<leader>p); prompts for the question if omitted
--   :Ask! [question]     fork the most recent Claude Code session in this repo (<leader>q)
--                        (forked, so the interactive session isn't touched)
--
-- In the answer window:  a = follow-up question in the same session, q = close.
--
-- Runs `claude -p` headless in the repo root, so Claude can read surrounding
-- code and `git diff` on its own; the prompt only carries file + line range.

local M = {}

M.config = {
  model = nil, -- nil = CLI default
  allowed_tools = "Read,Grep,Glob,Bash(git diff *),Bash(git log *),Bash(git show *),Bash(git blame *)",
  diff_base = "origin/main",
  max_diff_lines = 400,
  width = 0.6,
  height = 0.6,
}

local function repo_root()
  return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

local function is_diff_buffer()
  local ft = vim.bo.filetype
  return ft == "diff" or ft == "git" or ft == "gitcommit" or ft == "fugitive"
end

local function buf_display_name(win)
  local abs = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
  if abs == "" then return "[No Name]" end
  return vim.fs.relpath(repo_root(), abs) or abs
end

-- When the current window is one pane of an nvimdiff (`nvim -d`, `git difftool`,
-- fugitive Gdiffsplit), diff the leftmost pane against the rightmost one so the
-- prompt carries the actual change, not just the selected side.
local function nvimdiff_context()
  if not vim.wo.diff then return nil end
  local wins = vim.tbl_filter(function(w) return vim.wo[w].diff end, vim.api.nvim_tabpage_list_wins(0))
  if #wins < 2 then return nil end
  table.sort(wins, function(a, b)
    return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
  end)
  local left, right = wins[1], wins[#wins]
  local function text(win)
    return table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false), "\n") .. "\n"
  end
  local diff = vim.diff(text(left), text(right), { ctxlen = 3 })
  local lines = vim.split(diff, "\n")
  if #lines > M.config.max_diff_lines then
    lines = vim.list_slice(lines, 1, M.config.max_diff_lines)
    table.insert(lines, "... (diff truncated)")
  end
  local cur = vim.api.nvim_get_current_win()
  return {
    diff = table.concat(lines, "\n"),
    side = cur == left and "left (before)" or "right (after)",
    left = buf_display_name(left),
    right = buf_display_name(right),
  }
end

local function build_prompt(opts, question)
  local code = table.concat(vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false), "\n")
  local where = opts.line1 == opts.line2 and ("line " .. opts.line1)
    or ("lines " .. opts.line1 .. "-" .. opts.line2)
  local parts = { "I'm reviewing my branch." }
  local nvimdiff = nvimdiff_context()

  if nvimdiff then
    vim.list_extend(parts, {
      string.format("I'm in nvimdiff comparing %s (before) with %s (after). My selection is on the %s side, %s:",
        nvimdiff.left, nvimdiff.right, nvimdiff.side, where),
      "```",
      code,
      "```",
      "Full diff between the two panes:",
      "```diff",
      nvimdiff.diff,
      "```",
    })
  elseif is_diff_buffer() then
    vim.list_extend(parts, { "This hunk from the diff:", "```diff", code, "```" })
  else
    vim.list_extend(parts, {
      string.format("In %s, %s:", buf_display_name(0), where),
      "```",
      code,
      "```",
    })
  end

  vim.list_extend(parts, {
    question,
    "",
    "Read the surrounding code and `git diff " .. M.config.diff_base .. "` as needed to answer in context.",
    "Be concise; answer the question rather than describing the code line by line.",
  })
  return table.concat(parts, "\n")
end

local function open_answer_window(text, session_id)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.b[buf].ask_claude_session = session_id

  local w = math.floor(vim.o.columns * M.config.width)
  local h = math.floor(vim.o.lines * M.config.height)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    row = math.floor((vim.o.lines - h) / 2),
    col = math.floor((vim.o.columns - w) / 2),
    style = "minimal",
    border = "rounded",
    title = " Claude  (a: follow-up, q: close) ",
    title_pos = "center",
  })
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
  vim.keymap.set("n", "a", function()
    vim.ui.input({ prompt = "Follow-up: " }, function(q)
      if not q or q == "" then return end
      vim.api.nvim_win_close(win, true)
      M.run(q, { resume = session_id })
    end)
  end, { buffer = buf, nowait = true })
end

-- run_opts: { resume = <session id> } | { continue = true }
function M.run(prompt, run_opts)
  run_opts = run_opts or {}
  local argv = { "claude", "-p", "--output-format", "json", "--allowedTools", M.config.allowed_tools }
  if M.config.model then
    vim.list_extend(argv, { "--model", M.config.model })
  end
  if run_opts.resume then
    vim.list_extend(argv, { "--resume", run_opts.resume })
  elseif run_opts.continue then
    vim.list_extend(argv, { "--continue", "--fork-session" })
  end

  vim.notify("Asking Claude…", vim.log.levels.INFO)
  vim.system(argv, { stdin = prompt, cwd = repo_root(), text = true }, vim.schedule_wrap(function(res)
    local ok, parsed = pcall(vim.json.decode, res.stdout or "")
    if not ok or type(parsed) ~= "table" or not parsed.result then
      local err = (res.stderr and res.stderr ~= "" and res.stderr) or res.stdout or "no output"
      open_answer_window("claude exited " .. tostring(res.code) .. ":\n\n" .. err, nil)
      return
    end
    open_answer_window(parsed.result, parsed.session_id)
  end))
end

function M.ask(opts)
  local function go(question)
    if not question or question == "" then return end
    M.run(build_prompt(opts, question), { continue = opts.bang })
  end
  if opts.args ~= "" then
    go(opts.args)
  else
    vim.ui.input({ prompt = "Ask Claude: " }, go)
  end
end

vim.api.nvim_create_user_command("Ask", M.ask, {
  range = true,
  bang = true,
  nargs = "?",
  desc = "Ask Claude Code about the selected lines",
})
vim.keymap.set({ "n", "v" }, "<leader>q", ":Ask!<cr>", { silent = true, desc = "Ask Claude (fork most recent session)" })
vim.keymap.set({ "n", "v" }, "<leader>p", ":Ask<cr>", { silent = true, desc = "Ask Claude (fresh session)" })

return M
