enum LoadsSection { available, enRoute }

enum TripStatus { delivered, inProgress, pending, cancelled }

enum DocumentState { verified, expiringSoon }

class LoadOffer {
  const LoadOffer({
    required this.route,
    required this.customer,
    required this.company,
    required this.goods,
    required this.pickup,
    required this.distanceFromDriver,
    required this.estimatedProfit,
    required this.fuelCost,
    required this.tollCost,
    required this.capacityUsed,
    required this.truckFillLabel,
    required this.sharingTruckWith,
    required this.badgeLabel,
    required this.badgeEmoji,
    required this.routeDistance,
    required this.routeDuration,
    required this.weight,
    required this.dimensions,
    required this.stackable,
    required this.fragile,
    required this.specialHandling,
    required this.freightValue,
    required this.netProfit,
    required this.routeNote,
    required this.extraDistance,
    required this.extraEarnings,
    required this.spaceAvailable,
    required this.updatedTotalEarnings,
    this.bestProfit = false,
    this.routeSubtitle = '',
  });

  final String route;
  final String routeSubtitle;
  final String customer;
  final String company;
  final String goods;
  final String pickup;
  final String distanceFromDriver;
  final String estimatedProfit;
  final String fuelCost;
  final String tollCost;
  final double capacityUsed;
  final String truckFillLabel;
  final String sharingTruckWith;
  final String badgeLabel;
  final String badgeEmoji;
  final bool bestProfit;
  final String routeDistance;
  final String routeDuration;
  final String weight;
  final String dimensions;
  final String stackable;
  final String fragile;
  final String specialHandling;
  final String freightValue;
  final String netProfit;
  final String routeNote;
  final int extraDistance;
  final String extraEarnings;
  final String spaceAvailable;
  final String updatedTotalEarnings;
}

class DemandRoute {
  const DemandRoute({
    required this.route,
    required this.demand,
    required this.estimatedEarnings,
    required this.note,
  });

  final String route;
  final String demand;
  final String estimatedEarnings;
  final String note;
}

class TripStop {
  const TripStop({
    required this.customer,
    required this.route,
    required this.goods,
    required this.statusLabel,
    required this.earningsLabel,
    required this.tripPath,
    required this.dropLocation,
    required this.tonnes,
    required this.isCurrent,
    required this.isCompleted,
  });

  final String customer;
  final String route;
  final String goods;
  final String statusLabel;
  final String earningsLabel;
  final String tripPath;
  final String dropLocation;
  final String tonnes;
  final bool isCurrent;
  final bool isCompleted;
}

class TripRecord {
  const TripRecord({
    required this.route,
    required this.date,
    required this.earnings,
    required this.statusLabel,
    required this.tripId,
    required this.hash,
    required this.verifiedBadge,
    required this.completed,
  });

  final String route;
  final String date;
  final String earnings;
  final String statusLabel;
  final String tripId;
  final String hash;
  final String verifiedBadge;
  final bool completed;
}

class DocumentRecord {
  const DocumentRecord({
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusTone,
    required this.hash,
    required this.lastVerified,
    required this.validUntil,
    this.ctaLabel = 'View Document',
  });

  final String title;
  final String subtitle;
  final String statusLabel;
  final String statusTone;
  final String hash;
  final String lastVerified;
  final String validUntil;
  final String ctaLabel;
}
