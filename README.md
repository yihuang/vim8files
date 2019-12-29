### Install

```shell
ln -s $PROJ/init.vim $HOME/.vimrc
ln -s $PROJ/ $HOME/.vim
```

### Key Bindings

#### Common

`let mapleader = ","`

| Binding                             | Mode    | Description                                                  |
| ----------------------------------- | ------- | ------------------------------------------------------------ |
| `K`                                 | `N`     | Show documentation under cursor (`:h` for vim scripts, `CocAction('doHover')` for other file types) |
| `<leader><cr>`                      | `N`     | Clear search highlight                                       |
| `<leader>l`                         | `N`     | `:setl number!`                                              |
| `<leader>o`                         | `N`     | `:set paste!`                                                |
| `<leader>y`/`<leader>d`/`<leader>p` | `N`/`V` | Clipboard `"` version of `y`/`d`/`p`                         |
| `<leader>aj`                        | `N`     | `:ALENext`                                                   |
| `<leader>ak`                        | `N`     | `:ALEPrevious`                                               |
| `*`/`#`                             | `V`     | Visual version of `*`/`#`                                    |

#### CoC

| Binding                              | Mode | Description            |
| ------------------------------------ | ---- | ---------------------- |
| `<tab>`/`<s-tab>`/`<c-space>`/`<cr>` | `I`  | Auto-completion        |
| `gd`                                 | `N`  | Goto definition        |
| `gr`                                 | `N`  | Goto references        |
| `gf`                                 | `N`  | Quick fix current line |

#### LeaderF

| Binding     | Mode    | Description                                        |
| ----------- | ------- | -------------------------------------------------- |
| `<leader>f` | `N`     | Find files                                         |
| `<leader>b` | `N`     | List buffers in normal mode                        |
| `<leader>g` | `N`/`X` | Search symbol under cursor(or selection) full word |
| `<leader>G` | `N`/`X` | Search symbol under cursor(or selection)           |

#### Other

* `<leader>c*`: nerd commenter
* `<leader>M`: magit
