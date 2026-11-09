# Use the Layer 4 skill in Kimi Desktop Work mode

Date: 28 October 2026  
Scope: operating instructions only; no Layer 4 decisions or catalogue writes performed.

## 1. One-time setup in Kimi Desktop

1. Open the latest Kimi Desktop app and select **Work** mode. Work mode is the local agent that can use local Skills and remotely operate Kimi Browser Extension; ordinary Chat mode is not the required setup.
2. Open **Skills** in the Work-mode sidebar. If `cf-layer4-triage` / **Layer-4-Review** is already listed, no import is needed. Otherwise, use the local Skill upload/import action and select the existing `cf-layer4-triage.skill` package. Do not recreate it from an Office document.
3. Open **Plugins**, find **Kimi Browser Extension**, and install it. In Chrome or Edge, install and enable the matching browser extension as well.
4. Connect the local browser service:
   - In Kimi Work, open **Settings → Automation → External browser** and click **Connect**.
   - In the browser extension sidebar, open **Settings → Local agent remote control** and confirm **Connection: Connected**.
   - Opening the browser sidebar alone does not prove that Kimi Work can control the browser.
5. In that same Chrome or Edge browser, sign in to Platform Admin and open **Data pipeline → Layer 4 Review**. The skill package contains no credentials, cookies or authenticated session.

For the first run, select **Manual approval** in Kimi Work's permission control. **Default** is also available, but do not use **Fully automatic** for an initial live Layer 4 batch. Review each browser action and stop anything outside the existing Layer 4 UI workflow.

## 2. Start with one provider

In Kimi Desktop **Work → New Task**:

1. Type `/` in the task input.
2. Select the installed Skill shown as `cf-layer4-triage` or **Layer-4-Review**. Selecting it is preferable to typing an assumed slash name.
3. After the Skill has been inserted, enter:

```text
layer4-clear-all Federation University Australia
```

4. Send the task and keep Kimi Desktop, Chrome/Edge and the browser extension connected. Do not operate the same Layer 4 queue manually or from a second automation session while the batch is running.

A named-provider run is the recommended qualification run before attempting the full queue. It must process only that exact provider record, not similarly named providers.

## 3. Run the full queue after the qualification run

Invoke the same Skill with:

```text
layer4-clear-all
```

“Clear” means **review, decide and reconcile**, not delete records or force the queue to zero. The skill must:

- record an `L4B-YYYYMMDD-HHMM` batch id, baseline counts and provider checkpoints;
- process providers sequentially using stable item ids and stored evidence;
- use the existing UI choices and record an evidence-based reason containing the batch id;
- leave inadequate, conflicting or genuinely human decisions pending with an owner and next action;
- stop on authentication loss, repeated uncertain writes, shared reader/decision defects or unreliable queue state;
- report reconciled, admitted, left pending and newly raised separately.

The instruction does **not** authorise AI re-checks, Firecrawl or new source acquisition. Those require separate explicit authorisation. It also does not authorise SQL, deletion, select-all approval or direct write RPCs.

Until the Decided repair is released, retain the existing safeguard: verify through the current queue and lightweight universities/items views, and do not open the failing **Decided** view.

## 4. Resume an interrupted batch

Use the original batch id:

```text
layer4-clear-all resume L4B-YYYYMMDD-HHMM
```

Resume in the same Work task where the consolidated checkpoint is available. On another workstation, transfer that checkpoint separately; the `.skill` package contains the workflow but not batch state, browser authentication or chat history. The resume process must skip decided item ids, verify uncertain earlier actions before retrying and preserve the original batch id.

## 5. If something does not work

- **Skill not shown under `/`:** import the `.skill` package into Work mode's **Skills** area. Do not assume a Skill saved only in the browser sidebar is available to Kimi Work.
- **Browser tool unavailable or `extension_not_connected`:** confirm Chrome/Edge is open and the extension is enabled, then reconnect both **Work → Settings → Automation → External browser** and **extension → Settings → Local agent remote control**.
- **Platform Admin authentication fails:** sign in manually in the connected browser and reopen Layer 4 Review. Do not place credentials in the Skill or task prompt.
- **Repeated UI/database timeouts or uncertain writes:** stop the batch and retain its checkpoints. Do not repeatedly retry approvals, archives, publishes or rebuilds.
- **Items re-appear:** treat them as new work. Reconcile once only when the same evidence and rule apply; leave a repeated re-raise pending as a defect rather than entering a loop.

## Official Kimi references

- Kimi Work overview and Work-mode Skills interface: https://www.kimi.ai/help/kimi-work/overview
- Browser Extension installation and Kimi Work Desktop setup: https://www.kimi.ai/help/kimi-webbridge/kimi-webbridge-introduction
- Local Agent connection troubleshooting: https://www.kimi.ai/help/kimi-webbridge/kimi-webbridge-faq
- Invoking Skills with `/`: https://www.kimi.ai/help/plugins-and-skills/use-skills-in-agent
- Work permission modes: https://www.kimi.ai/help/kimi-work/kimi-work-faq
