(defvar magit-cache-location
  (expand-file-name ".cache/transient/" user-emacs-directory))

(setq
 completion-cycle-threshold t
 enable-recursive-minibuffers t
 initial-scratch-message ""
 split-width-threshold 0
 
 ;; Doesn't help
 ;; package-user-dir (expand-file-name ".cache/elpa/" user-emacs-directory)
 ;; Change location for Magit cache
 ;; transient-history-file (concat magit-cache-location "history.el")
 ;; transient-levels-file (concat magit-cache-location "levels.el")
 ;; transient-values-file (concat magit-cache-location "values.el")

 )

(global-set-key (kbd "M-=") 'text-scale-increase)
(global-set-key (kbd "M--") 'text-scale-decrease)

(savehist-mode 1)
(electric-pair-mode 1)

(provide 'emacs-config)
