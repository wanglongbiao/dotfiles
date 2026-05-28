syntax on
set number
set scrolloff=999
set mouse-=a
set noautoindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set tabstop=4       " 设置 Tab 为 4 个空格
set shiftwidth=4    " 设置自动缩进为 4 个空格
set expandtab       " 将 Tab 替换为空格
set noswapfile
set nowrap
set nobackup
set noswapfile
set noundofile
set nowritebackup
set pastetoggle=<F2>

" 设置Vim内部编码为UTF-8
set encoding=utf-8

" 自动检测文件编码的优先级列表
set fileencodings=ucs-bom,utf-8,gbk,big5,latin1

" 新文件默认保存编码
set fileencoding=utf-8

nmap J gT
nmap K gt
nmap q :wq<CR>
nmap <C-n> :tabnew<Esc>
nmap <C-e> :browse ol<CR>
"map <C-C> :w !xclip -selection clipboard
"map <C-c> "+y
"map <C-v> "+p


