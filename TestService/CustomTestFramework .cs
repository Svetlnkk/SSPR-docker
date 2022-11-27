using Xunit.Abstractions;
using Xunit.Sdk;
[assembly: Xunit.TestFramework("TestService.CustomTestFramework", "TestService")]

namespace TestService
{
    public class CustomTestFramework : XunitTestFramework
    {
        public CustomTestFramework(IMessageSink messageSink)
            : base(messageSink)
        {
            messageSink.OnMessage(new DiagnosticMessage("Using CustomTestFramework"));
        }
    }
}
