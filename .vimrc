if has("win32")
    set nocompatible
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif

call pathogen#infect()
syntax on
filetype plugin indent on
filetype indent on

set nu
set tabstop=4
set hlsearch
set incsearch
set shiftwidth=4
set autoindent
set expandtab
"set mouse=n

"禁止生成临时文件
set noswapfile

" 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set ignorecase smartcase

" 状态行显示的内容（包括文件类型和解码）
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]\ [%{strftime(\"%y/%m/%d\ -\ %H:%M\")}]
set laststatus=2

" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2

" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3

set ruler " 打开状态栏标尺

" nmap J 5j  
" nmap K 5k  

syntax enable
set background=dark
colorscheme solarized

" tags settting
set tags=tags;
" set tags=tags;/
" set autochdir

let NERDTreeChristmasTree=1
let NERDTreeMouseMode=2
let NERDTreeHighlightCursorline=0

let NERDCompactSexyComs=1
let NERDSpaceDelims=1

map <F2> :silent! NERDTreeToggle<CR>
map <F8> :silent! TagbarToggle<CR>
map <F9> :silent! FufCoverageFile<CR>

" 配色方案
if has("gui_running")
    colo solarized
else
    colo desert
endif
"--------------------------------------------------
" Name: solarized
" Description: 一个漂亮的配色方案
" Git: https://github.com/altercation/vim-colors-solarized.git
"--------------------------------------------------
let g:solarized_termcolors=256
let g:solarized_termtrans=0
let g:solarized_contrast="normal"
let g:solarized_visibility="high"
let g:solarized_underline=1
let g:solarized_italic=0
let g:solarized_degrade=0
let g:solarized_bold=1
let g:solarized_diffmode="normal"
let g:solarized_hitrail=0
let g:solarized_menu=1



"nmap a& :Tabularize /&<CR>
"vmap a& :Tabularize /&<CR>
nmap a= :Tabularize /=<CR>
vmap a= :Tabularize /=<CR>
"nmap a: :Tabularize /:<CR>
"vmap a: :Tabularize /:<CR>
"nmap a:: :Tabularize /:\zs<CR>
"vmap a:: :Tabularize /:\zs<CR>
"nmap a, :Tabularize /,<CR>
"vmap a, :Tabularize /,<CR>
"nmap a,, :Tabularize /,\zs<CR>
"vmap a,, :Tabularize /,\zs<CR>
"nmap a<Bar> :Tabularize /<Bar><CR>
"vmap a<Bar> :Tabularize /<Bar><CR>

" auto pair { and ( with } and )
imap { {<CR>}<ESC>O
" 输入左中括号的时候自动补齐右中括号，并在括号中间输入i
imap [ []<ESC>i
" 输入左小括号的时候自动补齐右小括号，并在括号中间输入i
imap ( ()<ESC>i

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.[ch],*.cpp,*.sh,*.java exec ":call SetTitle()" 
"定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1, "##########################################################################") 
        call append(line("."), "# File      Name: ".expand("%")) 
        call append(line(".")+1, "# Author: Danny Xiao")      
        call append(line(".")+2, "# mail: danny8303@gmail.com") 
        call append(line(".")+3, "# Created Time: ".strftime("%c")) 
        call append(line(".")+4, "#########################################################################") 
        call append(line(".")+5, "#!/bin/bash")
        call append(line(".")+8, "")
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "> File Name: ".expand("%")) 
        call append(line(".")+1, "> Author: Danny Xiao") 
        call append(line(".")+2, "> Mail: danny8303@gmail.com ") 
        call append(line(".")+3, "> Created Time: ".strftime("%c")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "")
    endif
    if &filetype == 'h'
        call InsertHeadDefN()
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "")
        call append(line(".")+8, "int main(int argc, char **argv)")
        call append(line(".")+9, "{")
        call append(line(".")+10, "    return 0;")
        call append(line(".")+11, "}")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype == 'java'
        call append(line(".")+6,"public class ".expand("%"))
        call append(line(".")+7,"call")
    endif
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G
endfunc 

autocmd FileType c,cpp set shiftwidth=4 | set noexpandtab
autocmd FileType java set shiftwidth=4 | set expandtab


function InsertHeadDef(firstLine, lastLine)
    if a:firstLine <1 || a:lastLine> line('$')
        echoerr 'InsertHeadDef : Range overflow !(FirstLine:'.a:firstLine.';LastLine:'.a:lastLine.';ValidRange:1~'.line('$').')'
        return ''
    endif
    let sourcefilename=expand("%:t")
    let definename=substitute(sourcefilename,' ','','g')
    let definename=substitute(definename,'\.','_','g')
    let definename = toupper(definename)
    exe 'normal '.a:firstLine.'GO'
    call setline('.', '#ifndef _'.definename."_")
    normal ==o
    call setline('.', '#define _'.definename."_")
    exe 'normal =='.(a:lastLine-a:firstLine+1).'jo'
    call setline('.', '#endif')
    let goLn = a:firstLine+2
    exe 'normal =='.goLn.'G'
endfunction
function InsertHeadDefN()
    let firstLine = 1
    let lastLine = line('$')
    let n=1
    while n < 20
        let line = getline(n)
        if n==1
            if line =~ '^\/\*.*$'
                let n = n + 1
                continue
            else
                break
            endif
        endif
        if line =~ '^.*\*\/$'
            let firstLine = n+1
            break
        endif
        let n = n + 1
    endwhile
    call InsertHeadDef(firstLine, lastLine)
endfunction
nmap ,ha :call InsertHeadDefN()<CR>

