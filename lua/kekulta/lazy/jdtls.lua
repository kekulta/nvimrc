return {
    {
        'mfussenegger/nvim-jdtls',
        enabled = false,
        config = function()
            local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
            local lsp_attach = function(client, bufnr)
                -- mappings here
            end

            local config = {
                cmd = { jdtls_bin },
                root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
                settings = {
                    java = {
                        referenceCodeLens = {
                            enabled = true
                        },
                        format = {
                            enabled = true,
                            insertSpaces = true
                        },
                        codeGeneration = {
                            tostring = {
                                listArrayContents = true,
                                skipNullValues = true
                            },
                            useBlocks = true,
                            hashCodeEquals = {
                                useInstanceof = true,
                                useJava7Objects = true
                            },
                            generateComments = true,
                            insertLocation = true
                        },
                        maven = {
                            downloadSources = true,
                            updateSnapshots = true
                        }
                    }
                },
                on_attach = lsp_attach,
            }
            require('jdtls').start_or_attach(config)
        end
    }
}
