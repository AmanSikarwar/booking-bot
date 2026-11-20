export interface QuotaDenial {
  code: "rate_limited" | "quota_exhausted";
  retry_after: number;
}

export class ModelQuotaExceeded extends Error {
  constructor(readonly retryAfter: number) {
    super("Daily model request limit reached");
  }
}

export function withModelBudget(reserve: () => Promise<QuotaDenial | null>, send: typeof fetch = fetch): typeof fetch {
  return async (input, init) => {
    const denial = await reserve();
    if (denial) throw new ModelQuotaExceeded(denial.retry_after);
    return send(input, init);
  };
}
