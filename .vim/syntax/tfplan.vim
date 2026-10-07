" Vim syntax file for human-readable Terraform plan output.
" Generate with: terraform plan -no-color > changes.plan
" For other filenames or stdin, use :setfiletype tfplan
if exists('b:current_syntax')
  finish
endif

syntax case match

syntax keyword terraformPlanKeyword resource data output
syntax keyword terraformPlanConstant true false null
syntax match terraformPlanNumber '\<\d\+\%(\.\d\+\)\?\>'
syntax region terraformPlanString start=+"+ skip=+\\.+ end=+"+ oneline
syntax match terraformPlanComment '^\s*#.*$'
syntax match terraformPlanKnown '(known after apply)'
syntax match terraformPlanSensitive '(sensitive value)'
syntax match terraformPlanArrow '->'

" Color the whole changed line, including nested attributes and legend entries.
syntax match terraformPlanAdd '^\s*+\%(/-\)\@!.*$'
syntax match terraformPlanDelete '^\s*-\%(/+\)\@!.*$'
syntax match terraformPlanChange '^\s*\~.*$'
syntax match terraformPlanReplace '^\s*\%(+/-\|-/+\).*$'
syntax match terraformPlanRead '^\s*<=.*$'
syntax match terraformPlanSummary '^Plan:.*$'
syntax match terraformPlanSummary '^Changes to Outputs:.*$'
syntax match terraformPlanSummary '^No changes\..*$'
syntax match terraformPlanWarning '# forces replacement\s*$' containedin=ALL

highlight default link terraformPlanKeyword Keyword
highlight default link terraformPlanConstant Constant
highlight default link terraformPlanNumber Number
highlight default link terraformPlanString String
highlight default link terraformPlanComment Comment
highlight default link terraformPlanKnown Special
highlight default link terraformPlanSensitive Special
highlight default link terraformPlanArrow Operator
highlight default link terraformPlanAdd DiffAdd
highlight default link terraformPlanDelete DiffDelete
highlight default link terraformPlanChange DiffChange
highlight default link terraformPlanReplace DiffChange
highlight default link terraformPlanRead DiffText
highlight default link terraformPlanSummary Title
highlight default link terraformPlanWarning WarningMsg

let b:current_syntax = 'tfplan'
