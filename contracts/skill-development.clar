;; Skill Development Contract
;; This contract tracks volunteer skill development

(define-data-var admin principal tx-sender)

;; Map to store skills
(define-map skills
  { skill-id: uint }
  {
    name: (string-utf8 50),
    description: (string-utf8 200),
    category: (string-utf8 50)
  }
)

;; Map to track volunteer skills
(define-map volunteer-skills
  { volunteer-id: principal, skill-id: uint }
  {
    level: uint, ;; 1-5 representing beginner to expert
    endorsements: uint,
    last-updated: uint
  }
)

;; Map to track endorsements
(define-map endorsements
  { volunteer-id: principal, skill-id: uint, endorser: principal }
  { endorsed: bool }
)

;; Counter for skill IDs
(define-data-var skill-counter uint u1)

;; Admin function to add a new skill
(define-public (add-skill (name (string-utf8 50)) (description (string-utf8 200)) (category (string-utf8 50)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403)) ;; Only admin can add skills
    (let ((skill-id (var-get skill-counter)))
      (map-set skills
        { skill-id: skill-id }
        {
          name: name,
          description: description,
          category: category
        }
      )
      (var-set skill-counter (+ skill-id u1))
      (ok skill-id)
    )
  )
)

;; Public function for volunteers to add a skill to their profile
(define-public (add-volunteer-skill (skill-id uint) (level uint))
  (begin
    (asserts! (<= level u5) (err u400)) ;; Level must be between 1-5
    (asserts! (>= level u1) (err u400))
    (asserts! (is-some (map-get? skills { skill-id: skill-id })) (err u404)) ;; Skill not found

    (ok (map-set volunteer-skills
      { volunteer-id: tx-sender, skill-id: skill-id }
      {
        level: level,
        endorsements: u0,
        last-updated: block-height
      }
    ))
  )
)

;; Public function to update skill level
(define-public (update-skill-level (skill-id uint) (new-level uint))
  (let ((skill (map-get? volunteer-skills { volunteer-id: tx-sender, skill-id: skill-id })))
    (asserts! (is-some skill) (err u404)) ;; Skill not found for volunteer
    (asserts! (<= new-level u5) (err u400)) ;; Level must be between 1-5
    (asserts! (>= new-level u1) (err u400))

    (ok (map-set volunteer-skills
      { volunteer-id: tx-sender, skill-id: skill-id }
      {
        level: new-level,
        endorsements: (get endorsements (unwrap-panic skill)),
        last-updated: block-height
      }
    ))
  )
)

;; Public function to endorse a volunteer's skill
(define-public (endorse-skill (volunteer-id principal) (skill-id uint))
  (let (
    (skill (map-get? volunteer-skills { volunteer-id: volunteer-id, skill-id: skill-id }))
    (existing-endorsement (map-get? endorsements { volunteer-id: volunteer-id, skill-id: skill-id, endorser: tx-sender }))
  )
    (asserts! (not (is-eq volunteer-id tx-sender)) (err u400)) ;; Cannot endorse yourself
    (asserts! (is-some skill) (err u404)) ;; Skill not found for volunteer
    (asserts! (is-none existing-endorsement) (err u409)) ;; Already endorsed

    (map-set endorsements
      { volunteer-id: volunteer-id, skill-id: skill-id, endorser: tx-sender }
      { endorsed: true }
    )

    (map-set volunteer-skills
      { volunteer-id: volunteer-id, skill-id: skill-id }
      {
        level: (get level (unwrap-panic skill)),
        endorsements: (+ (get endorsements (unwrap-panic skill)) u1),
        last-updated: block-height
      }
    )

    (ok true)
  )
)

;; Public function to get skill details
(define-read-only (get-skill (skill-id uint))
  (map-get? skills { skill-id: skill-id })
)

;; Public function to get volunteer skill details
(define-read-only (get-volunteer-skill (volunteer-id principal) (skill-id uint))
  (map-get? volunteer-skills { volunteer-id: volunteer-id, skill-id: skill-id })
)
