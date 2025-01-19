;; Set the directory for org-agenda files
(setq org-agenda-files '("~/repos/pers/notes"))
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 1))))
(setq org-default-notes-file "~/repos/pers/notes/Inbox.org")

(setq org-capture-templates
      '(("s" "Schedule task to inbox" entry
         (file+headline "~/repos/pers/notes/Inbox.org" "Inbox")
         "* TODO [#3] %?\12SCHEDULED: %T" :jump-to-captured nil)))

(setq org-capture-use-agenda-date t)
(setq org-agenda-show-future-repeats nil)
