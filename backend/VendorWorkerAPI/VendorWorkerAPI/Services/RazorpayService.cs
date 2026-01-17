using Razorpay.Api;
using System.Security.Cryptography;
using System.Text;

namespace VendorWorkerAPI.Services
{
    public class RazorpayService
    {
        private readonly RazorpayClient _client;
        private readonly string _secret;

        public RazorpayService(IConfiguration config)
        {
            var key = config["Razorpay:KeyId"];
            _secret = config["Razorpay:KeySecret"];

            _client = new RazorpayClient(key, _secret);
        }

        // ================= CREATE ORDER =================
        public Order CreateOrder(decimal amount)
        {
            var options = new Dictionary<string, object>
            {
                { "amount", (int)(amount * 100) }, // INR paise
                { "currency", "INR" },
                { "payment_capture", 1 }
            };

            return _client.Order.Create(options);
        }

        // ================= VERIFY SIGNATURE (CORRECT) =================
        public bool VerifySignature(
            string orderId,
            string paymentId,
            string razorpaySignature)
        {
            string payload = $"{orderId}|{paymentId}";

            using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(_secret));
            var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(payload));

            var generatedSignature = BitConverter
                .ToString(hash)
                .Replace("-", "")
                .ToLower();

            return generatedSignature == razorpaySignature;
        }
    }
}
