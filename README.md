
# Variables

Depends: 
    - embear/vim-foldsearch (for unfolding open tasks)

In case you have a directory for your wiki and blog files in markdown then you can set
```vim
    let g:wiki_dir = '~/Dropbox/PKD/vimwiki/'
    let g:blog_dir =  '~/Dropbox/PKD/blog_posts/'
```
These directories are required in case you want to open the correponing index files with your prefered key combinations. These keys you can set by
```vim
    let g:markdown_wiki_index_key = '<leader>W'
    let g:markdown_blog_index_key = '<leader>B'
```
