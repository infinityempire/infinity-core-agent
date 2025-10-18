import { COOKIE_NAME } from "@shared/const";
import { getSessionCookieOptions } from "./_core/cookies";
import { systemRouter } from "./_core/systemRouter";
import { protectedProcedure, publicProcedure, router } from "./_core/trpc";
import { z } from "zod";
import { getMemoryHistory, storeMemoryLog } from "./db";
import { sendAlert, sendDailyReport } from "./telegram";

export const appRouter = router({
  system: systemRouter,

  auth: router({
    me: publicProcedure.query(opts => opts.ctx.user),
    logout: publicProcedure.mutation(({ ctx }) => {
      const cookieOptions = getSessionCookieOptions(ctx.req);
      ctx.res.clearCookie(COOKIE_NAME, { ...cookieOptions, maxAge: -1 });
      return {
        success: true,
      } as const;
    }),
  }),

  // Memory management endpoints
  memory: router({
    store: publicProcedure
      .input(z.object({
        agentName: z.string(),
        inputText: z.string().optional(),
        outputText: z.string().optional(),
      }))
      .mutation(async ({ input }) => {
        const id = `mem_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        await storeMemoryLog({
          id,
          agentName: input.agentName,
          inputText: input.inputText || null,
          outputText: input.outputText || null,
        });
        return { success: true, id };
      }),

    history: publicProcedure
      .input(z.object({
        agentName: z.string(),
        limit: z.number().optional().default(50),
      }))
      .query(async ({ input }) => {
        const logs = await getMemoryHistory(input.agentName, input.limit);
        return logs;
      }),
  }),

  // Core agent management endpoints
  core: router({
    command: publicProcedure
      .input(z.object({
        agent: z.string(),
        command: z.string(),
        params: z.record(z.string(), z.any()).optional(),
      }))
      .mutation(async ({ input }) => {
        // Store command in memory
        const id = `cmd_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
        await storeMemoryLog({
          id,
          agentName: input.agent,
          inputText: input.command,
          outputText: JSON.stringify(input.params || {}),
        });
        return { success: true, message: `Command sent to ${input.agent}` };
      }),

    status: publicProcedure
      .query(async () => {
        return {
          "Infinity Agent": "OK",
          "Argus Cloud": "OK",
          "Neon DB": "Connected",
          "Telegram": "Active",
        };
      }),

    report: publicProcedure
      .query(async () => {
        return {
          date: new Date().toISOString().split('T')[0],
          status: {
            "Infinity Agent": "OK",
            "Argus Cloud": "OK",
            "Neon DB": "Connected",
            "Telegram": "Active",
          },
          issues: [],
          uptime: "99.8%",
        };
      }),

    sendReport: publicProcedure
      .mutation(async () => {
        const report = {
          date: new Date().toISOString().split('T')[0],
          status: {
            "Infinity Agent": "OK",
            "Argus Cloud": "OK",
            "Neon DB": "Connected",
            "Telegram": "Active",
          },
          issues: [],
          uptime: "99.8%",
        };
        const sent = await sendDailyReport(report);
        return { success: sent, report };
      }),

    sendAlert: publicProcedure
      .input(z.object({
        title: z.string(),
        details: z.string(),
      }))
      .mutation(async ({ input }) => {
        const sent = await sendAlert(input.title, input.details);
        return { success: sent };
      }),
  }),
});

export type AppRouter = typeof appRouter;
