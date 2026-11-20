# Saathi cost analysis

**Snapshot** · 20 November 2026 · Amounts are in USD unless marked ₹. INR figures use a planning rate of **₹90 per US dollar**. They exclude taxes, card conversion charges, and credit purchase fees.

Saathi recorded **$0.052986 (₹4.77)** in model spend in the hosted usage log. That is **9.5%** of the ₹50 take-home inference target in the [project plan](PLAN.md#1-problem). At the current app limits, a 30-day month that uses all 200 daily chat completion attempts would cost **about $0.82 (₹74)** at the historical average paid-call cost, or **about $1.80 (₹162)** at reference provider prices and observed median token sizes. These are scenarios for sustained usage. The release has only a short usage history.

## Recorded usage

The hosted `llm_usage` table covers 19 November 2026 at 19:31 UTC through 20 November at 05:39 UTC at the time of this snapshot. Counts include development, evaluation, and demo activity.

| Usage recorded | Rows | Logged spend |
| --- | ---: | ---: |
| DeepSeek V4.1 Flash 1017, successful | 383 | $0.052360 |
| GLM 5.3 Flash, successful | 4 | $0.000626 |
| Nemotron free fallback and chat mocks, successful | 12 | $0 |
| Chat errors and rate limits | 3 | $0 recorded |
| Decision API and decider mock, successful | 287 | $0 |
| **Total** | **689** | **$0.052986** |

- **Average paid chat call:** $0.000137 (₹0.0123) across the 387 rows with a nonzero cost. Tool follow-ups are separate model calls, so this figure is per call.
- **Token sizes:** Among 399 successful chat rows, the median was 1,705 input and 74 output tokens. The individual 95th percentiles were 1,924 input and 208 output tokens. The largest recorded input was 2,123 tokens and the largest output was 477 tokens.
- **Earlier benchmark:** The documented 68-turn evaluation recorded $0.015, with 97 paid-model calls and 65 free decision calls. Use that figure as a benchmark within the project's usage history. [Evaluation notes](evals/README.md#findings-run-of-2026-11-20)

The hosted figures sum provider-reported usage costs captured by Saathi. The adapter can retry before a usage row is written, and a failed or interrupted stream can lack final cost data. Use OpenRouter Activity or billing to reconcile the ledger with account charges. [Usage reporting code](supabase/functions/chat/llm.ts)

## Pricing and cost per turn

| Component | Pricing used in this analysis |
| --- | --- |
| DeepSeek V4.1 Flash 1017 | **$0.15 per million input tokens, $0.60 per million output tokens** at the listed DeepSeek endpoint. OpenRouter can route to other providers at different rates. The catalogue also listed a $0.60 / $2.40 high-price endpoint. |
| Gemma 4 26B and Nemotron 3.5 Super VL chat fallbacks | $0 per token for the configured free variants, subject to availability and OpenRouter limits. |
| Perplexity Decider Flash V1.3 | $0 per token for the configured free variant, subject to upstream limits. |

Prices and availability checked on 20 November 2026. [DeepSeek pricing](https://openrouter.ai/deepseek/deepseek-v4.1-flash-1017) · [Gemma free](https://openrouter.ai/google/gemma-4-26b-a4b-it:free) · [Nemotron free](https://openrouter.ai/nvidia/nemotron-3.5-super-vl:free) · [Decider free](https://openrouter.ai/perplexity/pplx-decider-flash-v1.3%3Afree/)

```text
Inference cost = (input tokens × input price per million
                + output tokens × output price per million) ÷ 1,000,000
```

At the reference price, one call with the observed median token counts costs **$0.000300 (₹0.027)**. The example search in `PLAN.md` uses two chat calls with about 2,900 input and 140 output tokens in total, for **$0.000519 (₹0.047)**. A booking action commonly uses two chat calls and skips the decider. A hard keyword match or replay of a completed turn uses zero model calls. A turn closed by the free decider incurs zero inference charge under the current model configuration. [Turn assumptions](PLAN.md#requests-per-turn) · [Server flow](supabase/functions/chat/agent.ts)

## Daily limits and spend scenarios

- **Public Chat API:** 10 authenticated POST requests per rolling minute and 200 per UTC day, shared across sessions. Retries, completed-turn replays, and malformed authenticated POSTs can consume this allowance.
- **Chat completions:** A separate pool allows 200 outbound attempts per UTC day. Tool follow-ups and adapter retries reserve from it, as do requests ultimately served by a free chat fallback. At two attempts per turn, the cap supports up to **100 tool-assisted turns per day** under that mix. Additional attempts reduce completed throughput.
- **Decision API:** Its calls sit outside the chat completion pool. The incoming authenticated POST still counts against the public Chat API allowance. OpenRouter publishes separate limits for free model usage, typically 20 requests per minute and 50 daily, rising to 1,000 daily with qualifying credit purchases. The account's allowance and upstream capacity can affect free-model availability.

Daily app limits reset at **00:00 UTC (05:30 IST)**. [Quota implementation](supabase/migrations/20261120031736_enforce_chat_quotas.sql) · [OpenRouter free model limits](https://openrouter.ai/collections/free-models)

The scenarios below assume **200 billable chat calls per day** and **30 days** at that rate. Free fallbacks and nonbillable attempts lower realized spend. The p95 row applies the two observed token percentiles to every call as a planning scenario.

| Scenario | USD per call | USD per day | USD per 30 days | INR per 30 days |
| --- | ---: | ---: | ---: | ---: |
| Historical average for paid calls | $0.000137 | $0.0274 | $0.82 | ₹74 |
| Median token counts at reference pricing | $0.000300 | $0.0600 | $1.80 | ₹162 |
| p95 token counts at reference pricing | $0.000413 | $0.0827 | $2.48 | ₹223 |
| 5,000 input and 1,000 output tokens at reference pricing | $0.001350 | $0.2700 | $8.10 | ₹729 |
| Same larger call at $0.60 / $2.40 per million | $0.005400 | $1.0800 | $32.40 | ₹2,916 |

The adapter requests a 1,000-token completion cap. The 5,000-token input figure is a stress-test assumption. The API limits message size and loads a fixed number of recent turns, while final prompt length also depends on history, tool payloads, and tokenization. Routing can change the price per token. The 200-attempt limit bounds request volume, so these scenarios should be used for planning. [Chat adapter](supabase/functions/chat/llm.ts) · [Request validation](supabase/functions/chat/index.ts)

## Hosting and other costs

| Item | Demo cost basis |
| --- | --- |
| Supabase | $0 base price on the Free plan, with 500,000 Edge Function invocations per month, 500 MB database size, and 5 GB egress included. The app's daily admission cap allows 6,000 admitted POSTs in 30 days, about 1.2% of the invocation allowance. Function traffic also includes rejected requests, health checks, and browser preflights. |
| GitHub Pages | Available on GitHub Free for a public repository. The site has a 100 GB monthly soft bandwidth limit. The custom domain is an existing asset, and its renewal cost is outside this estimate. |
| Android | APKs are distributed through GitHub Releases. The demo has no paid app store distribution, SMS delivery, lab inventory service, or payment processing in its flow. |
| OpenRouter credits | Credits are prepaid balance. Standard card top-ups carry a separate 5.5% fee with a $0.80 minimum. A $10 credit purchase would therefore cost $10.80 before tax and FX charges. The hosted usage total measures inference consumption. |

[Supabase pricing](https://supabase.com/pricing) · [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits) · [APK release](https://github.com/AmanSikarwar/booking-bot/releases/tag/v0.1.1) · [OpenRouter fees and controls](https://openrouter.ai/blog/insights/governing-team-ai-spend/)

## Keeping the take-home run under ₹50

At the planning exchange rate, ₹50 is **$0.556** of inference credit. The logged $0.052986 leaves roughly **$0.503 (₹45.23)**. That covers about eight full-cap days in the reference median scenario, or six in the p95 scenario. Sustained full-cap operation for a month exceeds the take-home target even at the historical paid-call average.

1. **Control dollar spend separately from request volume.** Check the dedicated OpenRouter key's remaining credit limit against the take-home balance. If a strict inference ceiling matters, set a non-resetting budget that accounts for spend already incurred across project keys. Its current configured value was outside this analysis. [OpenRouter spend controls](https://openrouter.ai/blog/insights/governing-team-ai-spend/)
2. **Limit routing price if predictability matters.** OpenRouter supports per-provider price ceilings through `provider.max_price`. Measure tool success, Hindi quality, and latency before tightening a ceiling because it can remove otherwise available providers. [OpenRouter cost controls](https://openrouter.ai/blog/tutorials/how-to-get-the-lowest-cost-llm-inference-on-openrouter/)
3. **Reserve hosted runs for integration and evaluation.** CI and mock development already avoid model spend. Track the cost per successful tool-assisted turn and the retry rate before tuning model calls or prompt size. Keep the free Decision API triage in place. [CI workflow](.github/workflows/ci.yml) · [Evaluation workflow](evals/README.md)

## Refreshing the snapshot

Run this aggregate query with read-only access to the hosted project. It returns daily usage by call type and model, without message contents or identifiers. Reconcile totals with OpenRouter's account activity for the same UTC window.

```sql
SELECT
  (created_at AT TIME ZONE 'UTC')::date AS utc_day,
  kind,
  model,
  status,
  count(*) AS logged_calls,
  sum(input_tokens) AS input_tokens,
  sum(output_tokens) AS output_tokens,
  sum(cost_usd) AS logged_usd
FROM public.llm_usage
GROUP BY 1, 2, 3, 4
ORDER BY 1, 2, 3, 4;
```
