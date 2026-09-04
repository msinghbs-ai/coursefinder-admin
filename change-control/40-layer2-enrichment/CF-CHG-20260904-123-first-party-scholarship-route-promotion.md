# CF-CHG-20260904-123 — First-Party Scholarship Route Promotion

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

New first-party Scholarship catalogue profiles inherit the governed Layer 2 acquisition route policy rather than bypassing provider routing. Direct HTTP remains preferred where qualified, with configured fallback providers subject to their existing availability, budget and qualification controls.

Federation UAT initially failed closed with `no_eligible_provider_route`; after governed route attachment it acquired the official catalogue successfully.