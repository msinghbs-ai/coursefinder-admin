# M2.4 Navigation Audit Screenshot Evidence

**Captured:** 26 August 2026  
**Browser:** PIM Admin v2.15.6 Go 7  
**Source run:** deployed UAT `32924717797` on Pilot SHA `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a`.

The source run later failed because inherited tests still searched for deliberately removed navigation labels/launchers. The Go 7 navigation tests and the screenshots represented here completed successfully before those inherited selector failures. The visible Go 7 UI did not change in the subsequent selector/audit-harness commits.

`go7-desktop-mobile-contact-sheet.jpg` is a compressed repository-resident contact sheet assembled from the retained Playwright screenshots. It includes representative evidence for:

- streamlined primary navigation;
- Guides & Runbooks;
- Layer 2 Enrichment;
- Layer 3 / Layer 4;
- Data Quality;
- Course detail;
- Evidence/provenance;
- Scholarship Selection;
- release notes;
- corresponding mobile surfaces where captured.

Full-resolution individual screenshots and runtime JSON remain in the GitHub Actions artifacts. A permanent `m2-4-navigation-content-audit.spec.mjs` now captures each menu item visible to the governed UAT role with heading/content sample, navigation elapsed time and screenshot on final deployed acceptance.

Platform Admin-only surfaces are not captured by elevating the lower-rank UAT account. Their relevance/security assessment is retained in `docs/coursefinder-m2-4-navigation-performance-content-audit-v1.0.md` and browser screenshots should be added only from an authorised Platform Admin acceptance session.
