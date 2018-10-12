" phoenix.vim - Shortcuts and settings for project with the Phoenix framework
" Maintainer: Arjan van der Gaag <http://arjanvandergaag.nl>
" Version: 0.1

if exists('g:loaded_phoenix') || &cp
  finish
endif
let g:loaded_phoenix = 1

augroup phoenix
  autocmd!

  " Setup when openening a file without a filetype
  autocmd BufNewFile,BufReadPost *
    \ if empty(&filetype) |
    \   call phoenix#Setup(expand('<amatch>:p')) |
    \ endif

  " Setup when launching Vim for a file with any filetype
  autocmd FileType * call phoenix#Setup(expand('%:p'))

  " Setup when launching Vim without a buffer
  autocmd VimEnter *
    \ if expand('<amatch>') == '' |
    \   call phoenix#Setup(getcwd()) |
    \ endif
augroup end

let s:project = substitute(getcwd(),".*/","","")

let s:projections = {
  \ "lib/". s:project. "_web/channels/*_channel.ex": {
  \   "type": "channel",
  \   "alternate": "test/". s:project. "_web/channels/{}_channel_test.exs"
  \ },
  \ "lib/". s:project. "_web/controllers/*_controller.ex": {
  \   "type": "controller",
  \   "alternate": "test/". s:project. "_web/controllers/{}_controller_test.exs"
  \ },
  \ "lib/". s:project. "_web/views/*_view.ex": {
  \   "type": "view",
  \   "alternate": "test/". s:project. "_web/views/{}_view_test.exs"
  \ },
  \ "lib/". s:project. "/*.ex": {
  \   "type": "context",
  \   "alternate": "test/". s:project. "/{}_test.exs"
  \ },
  \ "test/". s:project. "_web/channels/*_channel_test.exs": {
  \   "alternate": "lib/". s:project. "_web/channels/{}_channel.ex"
  \ },
  \ "test/". s:project. "_web/controllers/*_controller_test.exs": {
  \   "alternate": "lib/". s:project. "_web/controllers/{}_controller.ex"
  \ },
  \ "test/". s:project. "_web/views/*_view_test.exs": {
  \   "alternate": "lib/". s:project. "_web/views/{}_view.ex"
  \ },
  \ "test/". s:project. "/*_test.exs": {
  \   "alternate": "lib/". s:project. "/{}.ex"
  \ },
  \ "lib/". s:project. "_web/templates/*.html.eex": {
  \   "type": "template"
  \ },
  \ "lib/". s:project. "_web/router.ex": {
  \   "type": "router"
  \ },
  \ "assets/static/css/*": {
  \   "type": "stylesheet"
  \ },
  \ "assets/static/js/*": {
  \   "type": "javascript"
  \ },
  \ "config/*.exs": {
  \   "type": "config"
  \ },
  \ "lib/*": {
  \   "type": "lib"
  \ },
  \ "priv/repo/migrations/*.exs": {
  \   "type": "migration"
  \ }
\ }

augroup phoenix_projections
  autocmd!
  autocmd User ProjectionistDetect call phoenix#ProjectionistDetect(s:projections)
augroup END

augroup phoenix_path
  autocmd!
  autocmd User Phoenix call phoenix#SetupSnippets()
  autocmd User Phoenix call phoenix#DefineMixCommand()
  autocmd User Phoenix call phoenix#SetupSurround()
  autocmd User Phoenix
        \ let &l:path = 'lib/'. s:project. '_web/**,assets/static/**,lib/**,test/**,config/**' . &path |
        \ let &l:suffixesadd = '.ex,.exs,.html.eex' . &suffixesadd
augroup END
