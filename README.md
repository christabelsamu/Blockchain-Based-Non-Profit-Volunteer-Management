# Blockchain-Based Non-Profit Volunteer Management System

This project implements a decentralized volunteer management system for non-profit organizations using Clarity smart contracts. The system enables organizations to verify volunteers, match them with opportunities, track their time contributions, develop their skills, and recognize their contributions.

## Smart Contracts

The system consists of five main smart contracts:

1. **Volunteer Verification Contract**: Validates volunteer participants and stores their information.
2. **Opportunity Matching Contract**: Manages volunteer opportunities and matches volunteers with appropriate positions.
3. **Time Tracking Contract**: Tracks and verifies volunteer time contributions.
4. **Skill Development Contract**: Manages volunteer skills, endorsements, and skill development.
5. **Recognition Program Contract**: Implements a badge and point system to recognize volunteer contributions.

## Features

- **Volunteer Registration and Verification**: Organizations can verify volunteer identities.
- **Opportunity Creation and Application**: Organizations can create opportunities, and volunteers can apply for them.
- **Time Logging and Verification**: Volunteers can log their time, which can be verified by organizations.
- **Skill Management**: Volunteers can add skills to their profiles and receive endorsements.
- **Recognition System**: Organizations can award badges and points to recognize volunteer contributions.

## Contract Functions

### Volunteer Verification Contract

- `register-volunteer`: Register as a new volunteer
- `verify-volunteer`: Admin function to verify a volunteer
- `is-verified`: Check if a volunteer is verified
- `get-volunteer-details`: Get details about a volunteer

### Opportunity Matching Contract

- `create-opportunity`: Create a new volunteer opportunity
- `apply-for-opportunity`: Apply for an existing opportunity
- `approve-application`: Approve a volunteer's application
- `get-opportunity`: Get details about an opportunity
- `get-application-status`: Check the status of an application

### Time Tracking Contract

- `log-time`: Log volunteer time for an opportunity
- `verify-time-entry`: Verify a volunteer's time entry
- `get-time-entry`: Get details about a time entry
- `get-total-hours`: Get the total hours contributed by a volunteer

### Skill Development Contract

- `add-skill`: Admin function to add a new skill to the system
- `add-volunteer-skill`: Add a skill to a volunteer's profile
- `update-skill-level`: Update the level of a volunteer's skill
- `endorse-skill`: Endorse another volunteer's skill
- `get-skill`: Get details about a skill
- `get-volunteer-skill`: Get details about a volunteer's skill

### Recognition Program Contract

- `create-badge`: Admin function to create a new badge
- `award-badge`: Award a badge to a volunteer
- `award-points`: Award points to a volunteer
- `get-badge`: Get details about a badge
- `has-badge`: Check if a volunteer has a specific badge
- `get-points`: Get the total points earned by a volunteer

## Getting Started

1. Clone this repository
2. Deploy the smart contracts to your blockchain network
3. Interact with the contracts using the provided functions

## Testing

Tests are written using Vitest and can be found in the `tests` directory. Run the tests using:

\`\`\`bash
npm test
\`\`\`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

