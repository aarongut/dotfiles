" Terraform's saved plans are binary; only highlight readable plan output.
autocmd BufRead,BufNewFile *.tfplan,*.tfplan.txt,*.plan,*.plan.txt
      \ if getline(1) !~# '^PK' | setfiletype tfplan | endif
