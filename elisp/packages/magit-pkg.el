(use-package magit
  :demand t)

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "g g"    '(magit-status :wk "Show magit status")))

(provide 'magit-pkg)
