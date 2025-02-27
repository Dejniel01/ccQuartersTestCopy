﻿using Google.Cloud.Firestore;

namespace VirtualTourAPI.Requests
{
    public class PostLinkRequest
    {
        public string? ParentId { get; set; }
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public double? Longitude { get; set; }
        public double? Latitude { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
