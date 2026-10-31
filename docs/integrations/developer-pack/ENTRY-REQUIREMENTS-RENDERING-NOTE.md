# Entry requirements — rendering note (for the entry fields release)

When an entry-matrix row has no minimum (`min_grade` null, `scale` "none"), show **"This qualification is considered case by case"**. Never show "no data", and never treat it as met.

When a row has `scale_stated` `false` (a grade printed without its grading scale; `scale` is `null`), show **"Published requirement: [min_grade]. The provider does not state a grading scale on this page; check the source or contact the provider."** Show the grade as printed; never add a percentage, ATAR equivalent or band. It is not case by case.
