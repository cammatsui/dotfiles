return {
  'cam-matsui/redline.nvim',
  opts = {
    -- Agent-review loop: review Claude Code / OpenCode's uncommitted changes,
    -- then export to a fixed gitignored file the agent reads back.
    export = { destination = '.redline/review.md', preamble = true },
    -- Re-read the working tree when nvim regains focus so the diff tracks the
    -- agent's ongoing edits without a manual :Review refresh.
    auto_refresh = true,
  },
}
