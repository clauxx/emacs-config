(setq org-agenda-files '("~/org")
      org-edit-src-content-indentation 0
      org-return-follows-link t
      calendar-week-start-day 1
      electric-indent-mode -1)

(use-package org-superstar
  :demand t
  :hook (org-mode . (lambda ()
		      (org-superstar-mode t)))
  :config
  (setq org-superstar-special-todo-items t))

(use-package deft
  :demand t
  :commands (deft)
  :config
  (setq deft-directory "~/org"
        deft-recursive t
        deft-extensions '("md" "org")))

(use-package evil-org
  :demand t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook (lambda ()
				  (evil-org-set-key-theme
				   '(textobjects insert navigation additional shift todo heading))))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; | Typing the below + TAB | Expands to ...                          |
;; |------------------------+-----------------------------------------|
;; | <a                     | '#+BEGIN_EXPORT ascii' … '#+END_EXPORT  |
;; | <c                     | '#+BEGIN_CENTER' … '#+END_CENTER'       |
;; | <C                     | '#+BEGIN_COMMENT' … '#+END_COMMENT'     |
;; | <e                     | '#+BEGIN_EXAMPLE' … '#+END_EXAMPLE'     |
;; | <E                     | '#+BEGIN_EXPORT' … '#+END_EXPORT'       |
;; | <h                     | '#+BEGIN_EXPORT html' … '#+END_EXPORT'  |
;; | <l                     | '#+BEGIN_EXPORT latex' … '#+END_EXPORT' |
;; | <q                     | '#+BEGIN_QUOTE' … '#+END_QUOTE'         |
;; | <s                     | '#+BEGIN_SRC' … '#+END_SRC'             |
;; | <v                     | '#+BEGIN_VERSE' … '#+END_VERSE'         |
(require 'org-tempo)

(provide 'org-pkg)
