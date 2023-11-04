return {
    "lewis6991/gitsigns.nvim",

    config = function()
    local gitsigns = require("gitsigns")


    gitsigns.setup({
        signs = {
            add          = { text = '│' },
            change       = { text = '│' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        }
    })
    local gs = package.loaded.gitsigns
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>hs", "<cmd>lua gs.stage_hunk()<cr>", {desc = "Stage Hunk"})
    keymap.set("n", "<leader>hr", "<cmd>lua gs.reset_hunk()<cr>", {desc = "Reset Hunk"})
    keymap.set("v", "<leader>hs", [[:lua gs.stage_hunk{vim.fn.line('.'), vim.fn.line('v')}<cr>]], {desc = "Stage Hunk in Visual"})
    keymap.set("v", "<leader>hr", [[:lua gs.reset_hunk{vim.fn.line('.'), vim.fn.line('v')}<cr>]], {desc = "Reset Hunk in Visual"})
    keymap.set("n", "<leader>hS", "<cmd>lua gs.stage_buffer()<cr>", {desc = "Stage Buffer"})
    keymap.set("n", "<leader>hu", "<cmd>lua gs.undo_stage_hunk()<cr>", {desc = "Undo Stage Hunk"})
    keymap.set("n", "<leader>hR", "<cmd>lua gs.reset_buffer()<cr>", {desc = "Reset Buffer"})
    keymap.set("n", "<leader>hp", "<cmd>lua gs.preview_hunk()<cr>", {desc = "Preview Hunk"})
    keymap.set("n", "<leader>hb", [[:lua gs.blame_line{full=true}<cr>]], {desc = "Blame Line"})
    keymap.set("n", "<leader>tb", "<cmd>lua gs.toggle_current_line_blame()<cr>", {desc = "Toggle Line Blame"})
    keymap.set("n", "<leader>hd", "<cmd>lua gs.diffthis()<cr>", {desc = "Diff This"})
    keymap.set("n", "<leader>hD", [[:lua gs.diffthis('~')<cr>]], {desc = "Diff This with ~"})
    keymap.set("n", "<leader>td", "<cmd>lua gs.toggle_deleted()<cr>", {desc = "Toggle Deleted"})

    end
}
