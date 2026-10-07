" Terraform's saved plans are binary; only highlight readable plan output.
autocmd BufRead,BufNewFile *.tfplan,*.tfplan.txt,*.plan,*.plan.txt
      \ if getline(1) !~# '^PK' | setfiletype tfplan | endif

" Recognize redirected plan output saved with a generic .txt filename.
autocmd BufRead *.txt
      \ if index(getline(1, 100), 'Terraform used the selected providers to generate the following execution') >= 0
      \ || index(getline(1, 100), 'Terraform will perform the following actions:') >= 0
      \ | setlocal filetype=tfplan | endif
