namespace VendorWorkerAPI.Models
{
    public class RazorpayVerifyRequest
    {
        public string RazorpayOrderId { get; set; } = "";
        public string RazorpayPaymentId { get; set; } = "";
        public string RazorpaySignature { get; set; } = "";
    }
}
