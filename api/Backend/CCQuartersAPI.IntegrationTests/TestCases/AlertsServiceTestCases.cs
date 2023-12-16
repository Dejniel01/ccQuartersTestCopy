﻿using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Google.Cloud.Firestore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests.Mocks
{
    internal static class AlertsServiceTestCases
    {
        public static AlertDTO ExampleAlert { get; } = new()
        {
            MinPrice = 600000,
            MaxPrice = 1000000,
            MaxPricePerM2 = 15000,
            MinArea = 49.5m,
            MaxArea = 60.5m,
            MinRoomCount = 4,
            MaxRoomCount = 6,
            Floors = new[] { 3, 4 },
            OfferType = OfferType.Sale,
            BuildingType = BuildingType.Apartment,
            Cities = new[] { "Warszawa", "Łódź" }
        };
    }
}
