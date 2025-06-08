;; Recognition Program Contract
;; This contract recognizes volunteer contributions

(define-data-var admin principal tx-sender)

;; Map to store badges
(define-map badges
  { badge-id: uint }
  {
    name: (string-utf8 50),
    description: (string-utf8 200),
    image-url: (string-utf8 200),
    criteria: (string-utf8 500)
  }
)

;; Map to track volunteer badges
(define-map volunteer-badges
  { volunteer-id: principal, badge-id: uint }
  {
    awarded-at: uint,
    awarded-by: principal
  }
)

;; Map to track volunteer points
(define-map volunteer-points
  { volunteer-id: principal }
  { points: uint }
)

;; Counter for badge IDs
(define-data-var badge-counter uint u1)

;; Admin function to create a new badge
(define-public (create-badge
  (name (string-utf8 50))
  (description (string-utf8 200))
  (image-url (string-utf8 200))
  (criteria (string-utf8 500)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403)) ;; Only admin can create badges
    (let ((badge-id (var-get badge-counter)))
      (map-set badges
        { badge-id: badge-id }
        {
          name: name,
          description: description,
          image-url: image-url,
          criteria: criteria
        }
      )
      (var-set badge-counter (+ badge-id u1))
      (ok badge-id)
    )
  )
)

;; Admin or organization function to award a badge to a volunteer
(define-public (award-badge (volunteer-id principal) (badge-id uint))
  (begin
    (asserts! (is-some (map-get? badges { badge-id: badge-id })) (err u404)) ;; Badge not found
    (asserts! (is-none (map-get? volunteer-badges { volunteer-id: volunteer-id, badge-id: badge-id })) (err u409)) ;; Already awarded

    (map-set volunteer-badges
      { volunteer-id: volunteer-id, badge-id: badge-id }
      {
        awarded-at: block-height,
        awarded-by: tx-sender
      }
    )

    (ok true)
  )
)

;; Admin or organization function to award points to a volunteer
(define-public (award-points (volunteer-id principal) (points-to-add uint))
  (let ((current-points (default-to { points: u0 } (map-get? volunteer-points { volunteer-id: volunteer-id }))))
    (map-set volunteer-points
      { volunteer-id: volunteer-id }
      { points: (+ (get points current-points) points-to-add) }
    )
    (ok (+ (get points current-points) points-to-add))
  )
)

;; Public function to get badge details
(define-read-only (get-badge (badge-id uint))
  (map-get? badges { badge-id: badge-id })
)

;; Public function to check if a volunteer has a badge
(define-read-only (has-badge (volunteer-id principal) (badge-id uint))
  (is-some (map-get? volunteer-badges { volunteer-id: volunteer-id, badge-id: badge-id }))
)

;; Public function to get volunteer points
(define-read-only (get-points (volunteer-id principal))
  (let ((points (map-get? volunteer-points { volunteer-id: volunteer-id })))
    (if (is-some points)
      (get points (unwrap-panic points))
      u0
    )
  )
)
