" Decrease transparency (reset if below a threshold)
function! DecreaseTransparency()
	let g:transparency=g:transparency - g:trans_inc
	" Threshold
	if (g:transparency < g:trans_min)
		call libcallnr("vimtweak.dll", "SetAlpha", 254)
		let g:transparency = g:trans_min " 255
	endif
	" Actually set the transparency
	call libcallnr("vimtweak.dll", "SetAlpha", g:transparency)
	echo "Set transparency to ".g:transparency
endfunc

" Decrease transparency (reset if below a threshold)
function! IncreaseTransparency()
	let g:transparency=g:transparency + g:trans_inc
	" Threshold
	if(g:transparency > 255)
		let g:transparency = 255 " g:trans_min
	endif
	call libcallnr("vimtweak.dll", "SetAlpha", g:transparency)
	echo "Set transparency to ".g:transparency
endfunc


" If we're transparent, make it solid
" If we're solid, set the transparency to 195
function! ToggleTransparency()
	if (g:transparency < 255)
		let g:transparency = 255
	else
		let g:transparency = g:trans_pref
    endif
	call libcallnr("vimtweak.dll", "SetAlpha", g:transparency)
	echo "Set transparency to ".g:transparency
endfunc

" Rotate through the list of themes up above
function! RotateTheme()
	let g:theme = g:theme + 1
	if(g:theme >= len(g:themes))
		let g:theme = 0
	endif
	exec 'colorscheme '.g:themes[g:theme]
endfunc

" Toggle between Automatic, Absolute, and Relative line numbering
function! ToggleRelNumbering()
	let g:relnum_state = g:relnum_state + 1
	if (g:relnum_state > 2)
		let g:relnum_state = 0
		call EnableAutoRelNumberToggling()
		set relativenumber " We're in normal mode and focused
		echo "Automatic Line number toggling enabled"
	else
		call DisableAutoRelNumberToggling()
		if(&relativenumber == 1)
			set number
			echo "Line numbering - Absolute"
		else
			set relativenumber
			echo "Line numbering - Relative"
		endif
	endif
endfunc

function! EnableAutoRelNumberToggling()
	" Display absolute numbers when we lose focus
	autocmd FocusLost * :set number
	"Display relative numbers when we gain focus
	autocmd FocusGained * :set relativenumber
	" Display absolute numbers in insert mode
	autocmd InsertEnter * :set number
	" Display relative numbers when we leave insert mode
	autocmd InsertLeave * :set relativenumber
endfunc

" 0 - auto; 1 - manual; 2 - manual
if !exists("g:relnum_state")
	let g:relnum_state = 0
	call EnableAutoRelNumberToggling()
endif


function! DisableAutoRelNumberToggling()
	" Don't display absolute numbers when we lose focus
	autocmd! FocusLost *
	"Don't display relative numbers when we gain focus
	autocmd! FocusGained *
	" Don't display absolute numbers in insert mode
	autocmd! InsertEnter *
	" Don't display relative numbers when we leave insert mode
	autocmd! InsertLeave *
endfunc

" Mappings
" nnoremap <F10> :call DecreaseTransparency()<CR>
" nnoremap <F11> :call IncreaseTransparency()<CR>
" nnoremap <c-F11> :call ToggleTransparency()<CR>
nnoremap <c-F12> :call RotateTheme()<CR>
nnoremap <leader><c-n> :call ToggleRelNumbering()<CR>

" Global Variables for this script:
let g:transparency=255
let g:themes = ["peachpuff","molokai"]
let g:theme = 0
let g:trans_inc = 20
let g:trans_min = 135
let g:trans_pref = 195

" Run these functions:
call EnableAutoRelNumberToggling()


" runtime vimrc_example.vim
" runtime mswin.vim
" runtime macros/matchit.vim
" behave mswin
" set guifont=Triskweline:h11
" set guifont=Bitstream_Vera_Sans_Mono:h9


" backspace delete in visual mode
vnoremap <BS> d
" copy
vnoremap <c-c> "+y
" paste
map <c-v> "+gP
imap <c-v> <c-r>+
cmap <c-v> <c-r>+
" cut
vmap <c-x> d
" undo
inoremap <c-z> <c-o>u
noremap <c-z> u
" ctrl-v key sequence
noremap <c-q> <c-v>


set backupdir=~/Dropbox/vimbackup//
set directory=~/vimswap//
set udir=~/vimundo//
cd ~

" UltiSnips configuration
let g:UltiSnipsExpandTrigger="<C-J>"
let g:UltiSnipsListSnippets="<C-H>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


"Simplenote Configuration
source ~/.vim/simplenote.vim

"NERDTree
let g:NERDTreeBookmarksFile="/home/corey/.vim/_nerdtreebookmarks"

" Menu of all the things that I use:
function! MyMenu()
    if exists("g:loaded_my_menu")
        try
            silent! aunmenu my
        endtry
    endif
    let g:loaded_my_menu = 1

    if g:colors_name == "my" && g:my_menu != 0
		amenu &My\ Menu.&NERD\ Tree.&Toggle       :NERDTreeToggle
    endif
endfunction
