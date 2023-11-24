(use-package evil-mc
  :demand t
  :config
  (global-evil-mc-mode 1))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "m" '(:ignore :wk "multicursors")
   "m a" '(evil-mc-make-all-cursors :wk "Add cursors to all")
   "m c" '(evil-mc-undo-all-cursors :wk "Undo all cursors")
   "m m" '(evil-mc-make-and-goto-next-match :wk "Add cursor and go to next")
   "m u" '(evil-mc-undo-last-added-cursor :wk "Undo cursor")
   "m s" '(evil-mc-skip-and-goto-next-match :wk "Skip cursor and go to next")
   "m p" '(evil-mc-pause-cursors :wk "Pause cursors")
   "m r" '(evil-mc-resume-cursors :wk "Resume cursors")))

(provide 'multiple-cursors-pkg)
