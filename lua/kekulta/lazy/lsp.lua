return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        -- bridges the gap between mason and lspconfig
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = true }
        },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
            "RobertBrunhage/dart-tools.nvim",
            "akinsho/flutter-tools.nvim",
            "udalov/kotlin-vim",
        },

        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local capabilities_lua = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require("fidget").setup({})
            require("mason").setup({
                PATH = "prepend"
            })
            local lsp_config = require("lspconfig")

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "bashls",
                    "jdtls",
                    "jsonls",
                    "clangd",
                    -- "kotlin_language_server",
                },
                handlers = {
                    ["lua_ls"] = function()
                        lsp_config.lua_ls.setup {
                            capabilities = capabilities_lua,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,

                    ["kotlin_language_server"] = function()
                        lsp_config.kotlin_language_server.setup {
                            capabilities = capabilities,
                            -- root_dir = lsp_config.util.root_pattern(''),
                            on_attach = function()
                                print("Attach KLS")
                            end,
                        }
                    end,

                    ["clangd"] = function()
                        lsp_config["clangd"].setup {
                            capabilities = capabilities,
                            on_attach = function()
                                print("Attach clangd")
                            end,
                        }
                    end,

                    function(server_name)
                        lsp_config[server_name].setup {
                            capabilities = capabilities,
                            on_attach = function()
                                print("Attach LSP: " .. server_name)
                            end,
                        }
                    end,
                }
            })


            -- Hot reload :)
            require("dart-tools")

            local ls = require("luasnip")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        ls.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if ls.jumpable(-1) then
                            ls.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            local rep = require("luasnip.extras").rep

            ls.add_snippets("dart", {
                s("frzd",
                    {
                        t({ "import 'package:flutter/foundation.dart';",
                            "import 'package:freezed_annotation/freezed_annotation.dart';", "", "" }),
                        t("part '"), i(1, "new_file"), t({ ".freezed.dart';", "" }),
                        t("part '"), rep(1), t({ ".g.dart';", "", "@freezed", "" }),
                        t("class "), i(2, "ClassName"), t(" with _$"), rep(2), t({ " {", "" }), t("\tconst factory "),
                        rep(2), t({ "(", "\t\t{" }), i(3, "params"), t({ "}) = _" }), rep(2), t({ ";", "" }), t(
                        "\tfactory "), rep(2), t(
                        ".fromJson(Map<String, Object?> json) => _$"), rep(2), t({ "FromJson(json);", "" }), t({ "}" })
                    }
                ),
            })

            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    }
}
