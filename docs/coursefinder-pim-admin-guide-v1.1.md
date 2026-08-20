# CourseFinder PIM Admin Guide v1.1

**Status:** LIVING GOVERNANCE GUIDE — CAMPUS/GEOGRAPHY SEMANTICS UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.0.md` for Provider/Course/Campus geography interpretation  
**Change Control:** `CF-CHG-20260820-001`, `CF-CHG-20260820-008`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

This version carries forward all unchanged rules in v1.0 and adds the following governed Provider/Course/Campus interpretation rules.

## Provider geography

Provider geography belongs to the canonical Provider record. Typical fields include country, subdivision/state/region, primary city, address and postcode.

It answers **where the Provider record is located/registered or primarily represented in the accepted source**. It does not answer where every Course is delivered.

Admin rule: never copy Provider State/City into a Course location field merely because a Course belongs to that Provider.

## Campus geography

A Campus is a canonical Provider-owned delivery location stored in `catalogue.campuses`.

Important semantics:

- `stable_key` identifies the Campus independently of its display name;
- country/subdivision/city/address/postcode belong to the Campus;
- Campus lifecycle/status and publication status are independent of the Provider and Course states;
- Campus `valid_from`/`valid_to` describe the Campus record validity where supplied;
- `NULL` validity dates mean no explicit window is stored, not that dates should be invented;
- Campus source/evidence proves the Campus observation itself.

## Course→Campus relationship

A Course is related to a Campus through `catalogue.course_campuses`.

This is a relationship observation, not a denormalised Course address.

Relationship fields include:

- `course_id`;
- `campus_id`;
- `delivery_mode`;
- `is_primary`;
- relationship `source_id`;
- relationship `evidence_id`.

Admin interpretation:

- `delivery_mode=on_campus` means the accepted relationship records on-campus delivery for that Course/Campus relationship;
- `is_primary=false` means the relationship is not marked primary; it does not invalidate the Campus;
- relationship source/evidence proves that the Course is linked to the Campus;
- Campus source/evidence proves the Campus record;
- these provenance layers remain conceptually distinct even when both originate from CRICOS.

## Required Course detail presentation

Use a dedicated heading such as **Course delivery campuses** rather than a generic geography block.

For each relationship show, at minimum:

- Campus name;
- city;
- State/Region using the Campus subdivision;
- Country using the Campus country;
- delivery mode;
- primary relationship flag where useful;
- Campus status and publication state;
- Campus verification/validity context;
- Campus source/evidence drill-down;
- Course→Campus relationship source/evidence drill-down.

Do not label Provider State as Course State. Do not infer Course geography from Provider geography when no accepted Course→Campus relationship exists.

## Empty Campus semantics

A Course with no accepted `catalogue.course_campuses` relationship must display an explicit relationship absence such as **No accepted Course delivery Campus relationship loaded**.

Do not:

- create a synthetic Campus to improve completeness;
- fall back to the Provider address as if it were Course delivery geography;
- interpret missing Campus scope on another observation as `all campuses` without a governed rule.

## Reference case — CRICOS 121174E

Provider: Swinburne University of Technology  
Course: Bachelor of Artificial Intelligence  
CRICOS Course Code: `121174E`

Provider geography currently includes AU / AU-VIC / Hawthorn.

The Course separately relates to:

**Hawthorn Campus John Street Hawthorn Swinburne University**

with AU / AU-VIC / Hawthorn, `delivery_mode=on_campus`, and separately retained Campus and Course→Campus provenance.

The fact that both observations currently resolve to Hawthorn/Victoria does not permit the Admin or Zoho contract to merge Provider geography and Course delivery geography into one field.

## Zoho/consumer mapping consequence

Do not expose a single ambiguous `State` field for Course records.

Curated consumer contracts should distinguish concepts such as:

- Provider Country / Provider State or Region;
- Course Campus Name;
- Course Campus Country;
- Course Campus State or Region;
- Course Campus City;
- Course Campus Delivery Mode;
- repeating Course Campus relationship where more than one accepted Campus exists.

Course Campus remains one-to-many/repeating where source data supports multiple delivery locations.

## Audit checklist

When reviewing Provider/Course/Campus geography:

1. resolve the Provider and Course by governed stable identifiers;
2. inspect Provider geography independently;
3. inspect canonical Campus identity independently;
4. inspect `catalogue.course_campuses` relationship independently;
5. compare Campus and relationship evidence separately;
6. verify the Admin UI does not substitute Provider geography for Course delivery geography;
7. preserve multiple Campus relationships rather than flattening to one location;
8. treat absence as an exception/data state, not permission to manufacture geography.
