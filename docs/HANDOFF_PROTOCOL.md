# SUTRA 3.2 Handoff Protocol

## Purpose

This document outlines the standardized process for handing off development work between AI assistant sessions. Following this protocol ensures consistent progress and maintains the project's architectural integrity.

## Session Structure

Each development session should follow this structure:

1. **Initialization**
   - Review previous session summary
   - Examine current repository state
   - Identify specific objectives for this session

2. **Development**
   - Focus on implementing specific components
   - Document decisions and rationale
   - Create/update tests as necessary

3. **Documentation**
   - Update relevant documentation
   - Create session summary
   - Define next steps

4. **Handoff**
   - Commit changes to GitHub
   - Create detailed handoff notes
   - Define tasks for the next session

## Session Summary Template

Each session should produce a summary document in `handoff/sessions/` with this format:

```markdown
# Session Summary: [SESSION_NAME]

**Date:** YYYY-MM-DD
**Session ID:** [SESSION_ID]
**Participants:** [PARTICIPANTS]

## Session Goal

[Brief description of what this session aimed to accomplish]

## Key Decisions

1. [Decision 1] - [Rationale]
2. [Decision 2] - [Rationale]
3. [Decision 3] - [Rationale]

## Progress Summary

### Completed Work

- [Item 1] - [Location/File/Path]
- [Item 2] - [Location/File/Path]
- [Item 3] - [Location/File/Path]

### Current State

[Brief description of the current state of the project, including any work in progress]

### Code Changes

```
[File Path 1] - [Description of changes]
[File Path 2] - [Description of changes]
[File Path 3] - [Description of changes]
```

## Next Steps

### Immediate Actions

- [ ] [Task 1] - [Assignee] - [Priority]
- [ ] [Task 2] - [Assignee] - [Priority]
- [ ] [Task 3] - [Assignee] - [Priority]

### Upcoming Milestones

- [Milestone 1] - [Target Date]
- [Milestone 2] - [Target Date]

## Open Issues

### Technical Questions

1. [Question 1]
   - Context: [Context]
   - Options: [Options]
   - Current thinking: [Current thinking]

2. [Question 2]
   - Context: [Context]
   - Options: [Options]
   - Current thinking: [Current thinking]

### Blockers

- [Blocker 1] - [Impact] - [Potential resolution]
- [Blocker 2] - [Impact] - [Potential resolution]

## Resources

- [Link to relevant documents]
- [Link to code repositories]
- [Link to external resources]

## Notes for Next Session

[Any specific notes or guidance for the next session]
```

## Task Tracking

Tasks should be tracked in `handoff/tasks/` with this format:

```markdown
# Task: [TASK_NAME]

**ID:** [TASK_ID]
**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
**Status:** [NOT_STARTED|IN_PROGRESS|BLOCKED|COMPLETED]
**Priority:** [LOW|MEDIUM|HIGH|CRITICAL]
**Component:** [CORE|TEST_FRAMEWORK|INTEGRATION|FRONTEND]

## Description

[Detailed description of the task]

## Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Dependencies

- [Dependency 1] - [Status]
- [Dependency 2] - [Status]

## Implementation Plan

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Technical Notes

[Any technical details, approaches, or considerations]

## Files to Modify

```
[File Path 1] - [Expected changes]
[File Path 2] - [Expected changes]
[File Path 3] - [Expected changes]
```

## Testing Strategy

[How this task will be tested]

## Progress Updates

### Update YYYY-MM-DD - [SESSION_ID]

[Progress update]

## Handoff Notes

[Specific notes for handoff between sessions or developers]

## Related Tasks

- [Related Task 1] - [Relationship]
- [Related Task 2] - [Relationship]
```

## Code Handoff

When working on code across multiple sessions:

1. **Clear State Comments**
   - Mark work-in-progress sections with `// WIP`
   - Document current implementation status with `// STATUS:`
   - Indicate known issues with `// FIXME:`
   - Highlight future work with `// TODO:`

2. **Commit Messages**
   - Start with component name: `[ComponentName] Description`
   - Include task ID if applicable: `[AlignmentRegistry] Implement registerEntity (TASK-002)`
   - Be specific about what changes were made

3. **In-Progress Work**
   - Create a WIP file in the relevant directory: `WIP-ComponentName.md`
   - Document current status and next steps
   - Link to relevant session summaries

## Continuity Maintenance

To maintain continuity between sessions:

1. **GitHub as Source of Truth**
   - All code and documentation must be committed to GitHub
   - GitHub issues should reflect current task status
   - Refer to specific commits/files in handoff notes

2. **Context Preservation**
   - Begin each session with repository URL and key files to examine
   - Reference previous session summaries
   - Include relevant technical context in handoff notes

3. **Implementation Verification**
   - Create tests before or alongside implementation
   - Ensure all tests pass before handoff
   - Document any failing tests with explanation

## Initial Session Prompt Template

When starting a new session, use this template:

```
I'm continuing development on the SUTRA 3.2 project (https://github.com/OneZeroEight-ai/SUTRA-3.2.git).

The previous session worked on [COMPONENT/TASK]. The current state is [DESCRIPTION].

For this session, I'd like to focus on:
1. [SPECIFIC OBJECTIVE 1]
2. [SPECIFIC OBJECTIVE 2]
3. [SPECIFIC OBJECTIVE 3]

Please start by examining:
- [FILE_PATH_1] - [WHAT TO LOOK FOR]
- [FILE_PATH_2] - [WHAT TO LOOK FOR]

Then help me implement [SPECIFIC COMPONENT/FUNCTION], following the interface defined in [INTERFACE_FILE].
```

## Cross-Component Development

When working across multiple components:

1. Define clear integration points
2. Document API contracts and data formats
3. Use the shared test fixtures in `integration/test/fixtures/`
4. Update the integration checklist in `integration/CHECKLIST.md`

## Progress Tracking

Track overall project progress:

1. Update task status in `handoff/tasks/`
2. Maintain the project board in GitHub
3. Update the roadmap with completed milestones
4. Document any changes to the development plan

## Handling Technical Debt

If technical debt accumulates:

1. Document it in `TECHNICAL_DEBT.md`
2. Create GitHub issues for significant debt items
3. Address high-priority debt before moving to new features
4. Include debt reduction in milestone planning
