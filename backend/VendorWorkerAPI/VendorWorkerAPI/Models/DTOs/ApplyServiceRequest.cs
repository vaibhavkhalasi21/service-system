public class ApplyServiceRequest
{
    // 📍 SERVICE LOCATION
    public double? ServiceLatitude { get; set; }
    public double? ServiceLongitude { get; set; }
    public string? ServiceAddress { get; set; }

    // 📍 WORKER LOCATION
    public double? WorkerLatitude { get; set; }
    public double? WorkerLongitude { get; set; }
}
