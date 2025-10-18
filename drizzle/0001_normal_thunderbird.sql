CREATE TABLE `memory_logs` (
	`id` varchar(64) NOT NULL,
	`timestamp` timestamp NOT NULL DEFAULT (now()),
	`agentName` varchar(128) NOT NULL,
	`inputText` text,
	`outputText` text,
	CONSTRAINT `memory_logs_id` PRIMARY KEY(`id`)
);
