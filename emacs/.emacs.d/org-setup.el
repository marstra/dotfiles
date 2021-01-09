;; open notes using f2
(global-set-key (kbd "<f2>") (lambda () (interactive) (find-file "~/repos/notes/Inbox.org")))
(setq org-agenda-files (list "~/repos/notes/Inbox.org"))
