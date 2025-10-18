import { mysqlEnum, mysqlTable, text, timestamp, varchar } from "drizzle-orm/mysql-core";

/**
 * Core user table backing auth flow.
 * Extend this file with additional tables as your product grows.
 * Columns use camelCase to match both database fields and generated types.
 */
export const users = mysqlTable("users", {
  id: varchar("id", { length: 64 }).primaryKey(),
  name: text("name"),
  email: varchar("email", { length: 320 }),
  loginMethod: varchar("loginMethod", { length: 64 }),
  role: mysqlEnum("role", ["user", "admin"]).default("user").notNull(),
  createdAt: timestamp("createdAt").defaultNow(),
  lastSignedIn: timestamp("lastSignedIn").defaultNow(),
});

export type User = typeof users.$inferSelect;
export type InsertUser = typeof users.$inferInsert;

// Memory logs table for storing agent interactions
export const memoryLogs = mysqlTable("memory_logs", {
  id: varchar("id", { length: 64 }).primaryKey(),
  timestamp: timestamp("timestamp").defaultNow().notNull(),
  agentName: varchar("agentName", { length: 128 }).notNull(),
  inputText: text("inputText"),
  outputText: text("outputText"),
});

export type MemoryLog = typeof memoryLogs.$inferSelect;
export type InsertMemoryLog = typeof memoryLogs.$inferInsert;
