(use-package magit
  :demand t)

(use-package forge
  :demand t
  :after magit)

(use-package transient
  :demand t
  :defer t)

(use-package code-review
  :demand t
  :after magit forge emojify
  ;; FIXME: remove when this PR is merged and released https://github.com/wandersoncferreira/code-review/pull/246
  :ensure (:host github :repo "https://github.com/phelrine/code-review.git" :branch "fix/closql-update")
  :config
  (setq code-review-auth-login-marker 'forge)
  (evil-make-overriding-map code-review-mode-map evil-default-state)
  (add-hook 'code-review-mode-hook #'emojify-mode))

(with-eval-after-load 'general
  (general-define-key
   :keymaps 'transient-base-map
   "<escape>" 'transient-quit-one)


  (general-define-key
   :keymaps 'forge-pullreq-section-map
   "r" 'code-review-forge-pr-at-point)

  ;; (general-define-key
  ;;  :keymaps 'magit-hunk-section-map
  ;;  "TAB" 'magit-section-toggle)

  (general-define-key
   :states 'normal
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "g f"    '(forge-dispatch :wk "Forge menu")
   "g n"    '(forge-list-notifications :wk "Notifications")
   "g g"    '(magit-status :wk "Magit status")))

(provide 'magit-pkg)
