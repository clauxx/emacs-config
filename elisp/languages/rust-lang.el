(use-package rustic
  :ensure t
  :custom
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-cargo-watch-command "clippy"))

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   :keymaps '(rustic-mode-map)
   :prefix cl/sigma-leader
   "r" '(rustic-cargo-run :wk "run")
   "t" '(rustic-cargo-current-test :wk "run current test")
   "T" '(rustic-cargo-test :wk "run tests")
   "d" '(rustic-doc-search :wk "doc search")
   "p" '(rustic-open-dependency-file :wk "open Cargo.toml")
   
   "c" '(:ignore t :wk "cargo")
   "c u" '(rustic-cargo-update :wk "cargo update")
   "c a" '(rustic-cargo-add :wk "cargo add dep")
   "c A" '(rustic-cargo-add-missing-dependencies :wk "cargo add missing deps")))

(provide 'rust-lang)
