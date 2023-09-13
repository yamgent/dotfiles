----- BOOTSTRAP LAZY.NVIM -----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Bootstrapping lazy.nvim")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

----- SETUP -----
local lsp_servers = {
    'rust_analyzer',
    'tsserver',
    'eslint',
    'jsonls',
    'cssls',
    'svelte',
    'lua_ls',
    'clangd',
    'gopls',
}

require("lazy").setup({
    -- Create ending brackets when starting bracket is entered
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- equivalent to: require("nvim-autopairs").setup({})
    },
    -- Git added/modified/removed signs/lines at the line number guide
    {
        'lewis6991/gitsigns.nvim',
        opts = {}
    },
    -- Git lens per line
    {
        'APZelos/blamer.nvim',
        config = function()
            vim.g.blamer_enabled = 1
        end
    },
    -- Ctrl+P file list
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('telescope').setup()
            local keyset = vim.keymap.set

            local project_files = function()
                vim.fn.system('git rev-parse --is-inside-work-tree')
                if vim.v.shell_error == 0 then
                    -- when inside a git repo, this will respect
                    -- gitignore
                    require "telescope.builtin".git_files({
                        show_untracked = true,
                    })
                else
                    require "telescope.builtin".find_files({
                        no_ignore = false,
                        hidden = true,
                    })
                end
            end

            keyset("n", "<C-p>", function() project_files() end, { silent = true })

            -- additional: live grep
            keyset("n", "<leader>f", function()
                require "telescope.builtin".live_grep({
                    layout_strategy = 'vertical',
                })
            end, { silent = true })

            -- additional: symbol searches
            keyset("n", "<leader>s", function() require "telescope.builtin".lsp_document_symbols() end)
            keyset("n", "<leader>S", function() require "telescope.builtin".lsp_workspace_symbols() end)
        end,
    },
    -- better algorithm for Ctrl-P
    {
        "natecraddock/telescope-zf-native.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension("zf-native")
        end
    },
    -- file browser
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require('telescope')
            local keyset = vim.keymap.set

            telescope.load_extension('file_browser')
            -- show current file's directory
            keyset("n", "<leader>e",
                function() telescope.extensions.file_browser.file_browser({ path = "%:p:h", }) end,
                { silent = true }
            )
            -- show project's root directory
            keyset("n", "<leader>E",
                function() telescope.extensions.file_browser.file_browser() end,
                { silent = true }
            )
        end
    },
    -- tree browser (floating)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                    },
                    hijack_netrw_behavior = "open_current",
                    window = {
                        mappings = {
                            ["h"] = "close_node",
                            ["l"] = "open",
                        },
                    },
                },
            })

            local keyset = vim.keymap.set
            keyset("n", "<Leader>t", ":Neotree float reveal<CR>", { silent = true })
            keyset("n", "<Leader>T", ":Neotree float<CR>", { silent = true })
        end
    },
    -- colorize HTML color codes, or even basic colors like red
    {
        'NvChad/nvim-colorizer.lua',
        opts = {}
    },
    -- colorize TODO, FIX, etc comments...
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    -- draw guide lines for indents
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.opt.list = true

            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
            }
        end
    },
    -- find and replace
    {
        'windwp/nvim-spectre',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local keyset = vim.keymap.set
            keyset("n", "<leader>F", function() require('spectre').open() end)
        end
    },
    -- statusbar
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            -- for 'winbar' (and inactive_winbar) options, it is only used by
            -- nvim-navic, so can get rid of 'winbar' options if we are
            -- no longer using breadcrumbs
            winbar = {
                lualine_b = { 'filename' },
                lualine_c = { "require'nvim-navic'.get_location()" }
            },
            inactive_winbar = {
                lualine_b = { 'filename' },
            }
        }
    },
    -- tpope: surround
    'tpope/vim-surround',
    -- tpope: git
    {
        'tpope/vim-fugitive',
        config = function()
            local keyset = vim.keymap.set
            keyset("n", "<Leader>g", ":Git<CR>")
            -- Don't press <CR>, allowing args to be filled
            keyset("n", "<Leader>G", ":Git<Space>")
        end
    },
    -- tpope: comment
    'tpope/vim-commentary',
    -- file jump list (harpoon)
    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local keyset = vim.keymap.set
            keyset("n", "<Leader>h", function() require("harpoon.mark").add_file() end)
            keyset("n", "<Leader>H", function() require("harpoon.ui").toggle_quick_menu() end)
            keyset("n", "\\", function() require("harpoon.ui").nav_file(vim.v.count1) end)
        end
    },
    -- treesitter syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "vim", "lua", "vimdoc",
                    "gitcommit", "gitignore",
                    "javascript", "typescript", "tsx", "css", "scss", "html", "vue", "svelte", "yaml",
                    "json", "jsonc",
                    "python",
                    "c", "cpp", "cmake",
                    "rust", "toml",
                    "go", "gomod",
                },
                -- install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,
                -- enable highlighting
                highlight = { enable = true },
                -- enable indent behaviour when using '=' operator
                indent = { enable = true },
            })
        end
    },
    -- mason: manager for LSP, DAP, formatters, etc...
    {
        'williamboman/mason.nvim',
        opts = {},
    },
    -- mason configuration
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
        },
        opts = {
            ensure_installed = lsp_servers,
        },
    },
    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset({
                float_border = 'rounded',
                call_servers = 'local',         -- will be removed from v3.0
                setup_servers_on_start = false, -- will be removed from v3.0
            })

            lsp.setup_servers(lsp_servers)

            vim.opt.signcolumn = 'yes'

            lsp.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp.default_keymaps({ buffer = bufnr })

                local opts = { buffer = bufnr, remap = false }
                local keyset = vim.keymap.set
                keyset("n", "<C-k>", function() vim.diagnostic.goto_prev() end, opts)
                keyset("n", "<C-j>", function() vim.diagnostic.goto_next() end, opts)
                keyset("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                keyset("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
            end)

            lsp.setup()

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    format = function(d)
                        local code = d.code or (d.user_data and d.user_data.lsp.code)
                        if code then
                            return string.format("%s [%s]", d.message, code):gsub("1. ", "")
                        end
                        return d.message
                    end,
                },
            })

            -- format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function()
                    vim.lsp.buf.format()
                end
            })

            -- cmp
            lsp.extend_cmp({
                set_sources = 'recommended',
                set_basic_mappings = true,
                set_extra_mappings = false,
                use_luasnip = true,
                set_format = true,
                documentation_window = true,
            })
            local cmp = require('cmp')

            cmp.setup({
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }
            })
        end
    },
    -- lsp: fancy symbols in auto-complete
    {
        'onsails/lspkind.nvim',
        dependencies = {
            { 'hrsh7th/nvim-cmp' },
        },
        config = function()
            local lspkind = require('lspkind')
            lspkind.init({
                mode = 'symbol_text'
            })

            local cmp = require('cmp')
            cmp.setup {
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text'
                    })
                }
            }
        end
    },
    -- lsp: for prettier (make prettier become an lsp server)
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettierd
                }
            })
        end
    },
    -- lsp: inlay hints
    {
        'lvimuser/lsp-inlayhints.nvim',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
        },
        config = function()
            require('lsp-inlayhints').setup()

            -- boilerplate setup code for this plugin, to attach
            -- hints once LSP is activated
            vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_inlayhints",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp-inlayhints").on_attach(client, bufnr)
                end,
            })

            -- for typescript inlay hints
            require('lspconfig').tsserver.setup({
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    }
                }
            })
        end
    },
    -- lsp: lsp update messages
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            -- options
        },
    },
    -- lsp: code context breadcrumb
    {
        'SmiteshP/nvim-navic',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
        },
        opts = {
            lsp = {
                auto_attach = true,
            },
        }
    },
    -- dap
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap = require('dap')

            vim.fn.sign_define('DapBreakpoint', { text = '' })

            -- shortcuts
            local keyset = vim.keymap.set
            keyset('n', '<F5>', function() dap.continue() end)
            keyset('n', '<F6>', function() dap.terminate() end)
            keyset('n', '<F9>', function() dap.step_into() end)
            keyset('n', '<F10>', function() dap.step_over() end)
            keyset('n', '<F11>', function() dap.step_out() end)
            keyset('n', '<Leader>b', function() dap.toggle_breakpoint() end)
            keyset('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
            keyset('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            keyset('n', '<Leader>dl', function() dap.run_last() end)

            -- backup shortcuts in case F keys not readily available (e.g Mac with Touch Bar :/)
            keyset('n', '<Leader>dr', function() dap.continue() end)
            keyset('n', '<Leader>de', function() dap.terminate() end)
            keyset('n', '<Leader>di', function() dap.step_into() end)
            keyset('n', '<Leader>ds', function() dap.step_over() end)
            keyset('n', '<Leader>do', function() dap.step_out() end)
        end
    },
    -- dap: user interface
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup()

            -- hook for opening/closing dapui when debugging
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            local keyset = vim.keymap.set
            keyset('n', '<Leader>duo', function() dapui.open() end)
            keyset('n', '<Leader>duc', function() dapui.close() end)
        end
    },
    -- dap: install common adapters
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'mfussenegger/nvim-dap' },
        },
        config = function()
            require('mason-nvim-dap').setup({
                ensure_installed = { "delve", "codelldb" }
            })

            local dap = require('dap')

            ---- adapters
            -- lldb
            local lldb_cmd = vim.fn.stdpath("data") .. '/mason/packages/codelldb/codelldb'
            if vim.fn.has('win32') == 1 then
                lldb_cmd = vim.fn.stdpath("data") .. '/mason/packages/codelldb/extension/adapter/codelldb.exe'
            end

            dap.adapters.lldb = {
                type = 'server',
                port = "${port}",
                name = 'lldb',
                executable = {
                    command = lldb_cmd,
                    args = { "--port", "${port}" },

                    -- On windows you may have to uncomment this:
                    -- detached = false,
                }
            }

            ---- languages
            dap.configurations.rust = {
                {
                    name = "Launch lldb",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ",
                            vim.fn.getcwd() .. "/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    args = {},
                    runInTerminal = false,
                }
            }
        end
    },

    --- FANCY THEMES!
    -- THEME: gruvbox
    {
        'morhetz/gruvbox',
        config = function()
            -- vim.cmd('colorscheme gruvbox')
        end
    },
    -- THEME: tokyonight
    {
        'folke/tokyonight.nvim',
        config = function()
            -- vim.cmd('colorscheme tokyonight-night')
        end
    },
    -- THEME: vscode
    {
        'Mofiqul/vscode.nvim',
        config = function()
            -- vim.cmd('colorscheme vscode')
        end
    },
    -- THEME: onedark
    {
        'navarasu/onedark.nvim',
        config = function()
            -- vim.cmd('colorscheme onedark')
        end
    },
    -- THEME: kanagawa
    {
        'rebelot/kanagawa.nvim',
        config = function()
            vim.cmd('colorscheme kanagawa')
        end
    },
    -- THEME: darcula
    {
        'doums/darcula',
        config = function()
            -- vim.cmd('colorscheme darcula')
        end
    },
})
