# Lightweight Meeting Check‑In App Design

## 1) Product Goal
Build a **small, fast, web-based team check-in app** that helps teams run recurring meeting updates with minimal overhead.

Each check-in should capture:
- Team/member name
- Status: **On Track** or **Off Track**
- Short comment / blockers
- Timestamp

The app should provide:
- A simple entry UI (optimized for speed during meetings)
- A dashboard summary (current check-in health and trends)
- Low operational complexity and low AWS cost

---

## 2) Recommended Lightweight Architecture (AWS)

### Frontend
- **Framework:** React + Vite (or Next.js static export)
- **Hosting:** AWS S3 + CloudFront
- **Reason:** Very small runtime footprint, cheap, globally cached static assets

### Backend API
- **Runtime:** AWS Lambda (Node.js 22 / Python 3.12)
- **Gateway:** API Gateway HTTP API
- **Reason:** Serverless, no server management, scales to zero

### Database (lightweight + easy to manage)
- **Primary recommendation:** **Amazon DynamoDB** (on-demand)
  - No server admin
  - Handles bursty meeting traffic well
  - Good fit for key-value + document check-in records
- **Alternative:** Amazon Aurora Serverless v2 (PostgreSQL)
  - Use only if relational/reporting needs become complex

### Authentication (optional but recommended)
- **Amazon Cognito** (Google/Microsoft SSO or email login)
- Keep role model simple: `admin`, `member`

### Observability
- CloudWatch Logs + basic CloudWatch alarms (Lambda errors, API 5xx)

---

## 3) High-Level System Flow
1. User opens app (CloudFront -> static SPA from S3).
2. User submits check-in form.
3. SPA calls `POST /checkins` via API Gateway.
4. Lambda validates payload and writes to DynamoDB.
5. Dashboard calls `GET /dashboard/summary` + `GET /checkins?meetingId=...`.
6. Lambda aggregates and returns counts/trends.

---

## 4) Data Model (DynamoDB)

### Table: `MeetingCheckins`
- **PK:** `meetingId` (string)  
- **SK:** `createdAt#memberId` (string)

Attributes:
- `meetingId` (e.g., `eng-standup-2026-03-28`)
- `memberId`
- `memberName`
- `status` (`ON_TRACK` | `OFF_TRACK`)
- `comment` (string, max 500)
- `createdAt` (ISO timestamp)
- `teamId`

### GSI1 (for member history)
- `GSI1PK = teamId#memberId`
- `GSI1SK = createdAt`

This supports:
- Per-meeting summaries
- Team trend views
- Member-level history

---

## 5) API Design (Minimal)

### `POST /checkins`
Create a new check-in.

Request:
```json
{
  "meetingId": "eng-standup-2026-03-28",
  "teamId": "eng",
  "memberId": "u_123",
  "memberName": "Alex",
  "status": "OFF_TRACK",
  "comment": "Blocked on API credential"
}
```

Response:
```json
{
  "ok": true,
  "id": "eng-standup-2026-03-28#2026-03-28T09:00:00Z#u_123"
}
```

### `GET /checkins?meetingId=...`
Returns all check-ins for a meeting.

### `GET /dashboard/summary?teamId=...&windowDays=14`
Returns:
- Count on-track/off-track
- % off-track
- Top blocker keywords (optional)
- Recent meeting trend line

---

## 6) UI/UX Design (Simple + Fast)

### A) Check-In Entry View
- Single-card form:
  - Toggle buttons: **On Track** / **Off Track**
  - Comment text area
  - Submit button
- Keep keyboard-first flow:
  - Tab order optimized
  - `Ctrl/Cmd + Enter` submits
- Confirmation toast: “Check-in saved.”

### B) Meeting Board View
- Table/list of submitted entries in real time (poll every 10–15 sec or manual refresh)
- Row fields: member, status pill, comment, timestamp
- Quick filters: all / off-track only

### C) Dashboard View
- KPI cards:
  - Total check-ins
  - On-track count
  - Off-track count
  - Off-track rate
- 14-day trend sparkline
- “Current blockers” list from off-track comments

Design style:
- Neutral palette, clear contrast
- Use only 1–2 accent colors (green/red status)
- Avoid heavy component libraries if bundle size is a concern

---

## 7) Security + Governance
- API auth via Cognito JWT authorizer
- Validate + sanitize comment input server-side
- Enable CORS only for CloudFront domain
- Encrypt DynamoDB at rest (default) + TLS in transit
- CloudTrail enabled for audit visibility

---

## 8) Deployment Blueprint (Small Footprint)

### Infrastructure as Code
Use AWS SAM or Terraform for reproducible deploys:
- S3 bucket + CloudFront distro
- API Gateway routes
- Lambda functions
- DynamoDB table + GSI
- IAM least-privilege roles

### CI/CD (minimal)
GitHub Actions pipeline:
1. Run tests/lint
2. Build frontend
3. Deploy backend (SAM/Terraform)
4. Upload static assets to S3 + invalidate CloudFront cache

---

## 9) Estimated Cost Profile (low usage team)
For a small team (e.g., <200 check-ins/day):
- S3 + CloudFront: very low
- Lambda + API Gateway: pay-per-request, typically low
- DynamoDB on-demand: low for sparse writes/reads
- Cognito: often low/free tier depending MAU

This architecture is usually far cheaper than always-on EC2/RDS for this use case.

---

## 10) MVP Build Plan (2–3 weeks)

### Week 1
- Frontend skeleton (3 views)
- `POST /checkins`, `GET /checkins`
- DynamoDB table + basic deploy

### Week 2
- Dashboard summary endpoint
- Auth integration (Cognito)
- Basic alarms + logs

### Week 3 (optional hardening)
- Trend analytics optimization
- CSV export for meeting facilitators
- UI polish + accessibility pass

---

## 11) Future Enhancements
- Slack/Teams reminders before check-ins
- Auto-summarized blockers via LLM
- Department/portfolio roll-up dashboard
- Meeting templates and recurring schedules

---

## 12) Why this design fits the request
- **Streamlined check-in UX:** binary status + comments
- **Dashboard overview:** clear KPI/trend visibility
- **AWS deployable:** fully managed serverless services
- **Small footprint:** static frontend + Lambda + DynamoDB
- **Easy database ops:** DynamoDB removes patching/backups/server maintenance burden
