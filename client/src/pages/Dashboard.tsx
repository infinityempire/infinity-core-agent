import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { trpc } from "@/lib/trpc";
import { useEffect, useState } from "react";

export default function Dashboard() {
  const [autoRefresh, setAutoRefresh] = useState(false);
  
  const { data: status, refetch: refetchStatus } = trpc.core.status.useQuery();
  const { data: report, refetch: refetchReport } = trpc.core.report.useQuery();
  const sendReportMutation = trpc.core.sendReport.useMutation();
  const sendAlertMutation = trpc.core.sendAlert.useMutation();

  useEffect(() => {
    if (!autoRefresh) return;
    const interval = setInterval(() => {
      refetchStatus();
      refetchReport();
    }, 30000);
    return () => clearInterval(interval);
  }, [autoRefresh, refetchStatus, refetchReport]);

  const handleSendReport = async () => {
    await sendReportMutation.mutateAsync();
  };

  const handleSendTestAlert = async () => {
    await sendAlertMutation.mutateAsync({
      title: "Test Alert",
      details: "This is a test alert from Infinity Core Agent"
    });
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
      <div className="container mx-auto py-8 px-4">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-white mb-2">🧠 Infinity Core Agent</h1>
          <p className="text-slate-300">Central control unit for all Infinity systems</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          {status && Object.entries(status).map(([name, state]) => (
            <Card key={name} className="bg-slate-800/50 border-slate-700">
              <CardHeader className="pb-3">
                <CardTitle className="text-lg text-white">{name}</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="flex items-center gap-2">
                  <div className={`w-3 h-3 rounded-full ${state === 'OK' || state === 'Connected' || state === 'Active' ? 'bg-green-500' : 'bg-red-500'}`} />
                  <span className="text-slate-300">{state}</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <Card className="bg-slate-800/50 border-slate-700">
            <CardHeader>
              <CardTitle className="text-white">Daily Report</CardTitle>
              <CardDescription className="text-slate-400">System status and uptime metrics</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {report && (
                <div className="space-y-2 text-slate-300">
                  <p><strong>Date:</strong> {report.date}</p>
                  <p><strong>Uptime:</strong> {report.uptime}</p>
                  <p><strong>Issues:</strong> {report.issues.length > 0 ? report.issues.join(', ') : 'None'}</p>
                </div>
              )}
              <Button 
                onClick={handleSendReport}
                disabled={sendReportMutation.isPending}
                className="w-full"
              >
                {sendReportMutation.isPending ? 'Sending...' : 'Send Report to Telegram'}
              </Button>
            </CardContent>
          </Card>

          <Card className="bg-slate-800/50 border-slate-700">
            <CardHeader>
              <CardTitle className="text-white">System Controls</CardTitle>
              <CardDescription className="text-slate-400">Manage agents and notifications</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-slate-300">Auto-refresh (30s)</span>
                <Button
                  variant={autoRefresh ? "default" : "outline"}
                  size="sm"
                  onClick={() => setAutoRefresh(!autoRefresh)}
                >
                  {autoRefresh ? 'ON' : 'OFF'}
                </Button>
              </div>
              <Button 
                onClick={handleSendTestAlert}
                disabled={sendAlertMutation.isPending}
                variant="outline"
                className="w-full"
              >
                {sendAlertMutation.isPending ? 'Sending...' : 'Send Test Alert'}
              </Button>
            </CardContent>
          </Card>
        </div>

        <Card className="bg-slate-800/50 border-slate-700">
          <CardHeader>
            <CardTitle className="text-white">API Endpoints</CardTitle>
            <CardDescription className="text-slate-400">Available endpoints for agent communication</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2 text-sm font-mono text-slate-300">
              <p>POST /api/trpc/memory.store - Store interaction logs</p>
              <p>GET /api/trpc/memory.history - Retrieve memory by agent</p>
              <p>POST /api/trpc/core.command - Send commands to agents</p>
              <p>GET /api/trpc/core.status - Get system status</p>
              <p>GET /api/trpc/core.report - Get daily report</p>
              <p>POST /api/trpc/core.sendReport - Send report to Telegram</p>
              <p>POST /api/trpc/core.sendAlert - Send alert to Telegram</p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

