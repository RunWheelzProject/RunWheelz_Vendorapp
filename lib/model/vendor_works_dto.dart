class VendorWorksDTO {


  int? id;
  bool? electricWork;
  bool? painting;
  bool? spares;
  bool? washing;
  bool? puncture;
  bool? radiumWork;
  bool? seatCover;
  bool? meterRepair;
  bool? alignment;
  bool? chasiAlignment;
  bool? welding;
  bool? shockAbsorberRepair;
  bool? towing;
  bool? pickUpAndDrop;
  bool? authorisedServicePoint;
  bool? forkthTowing;
  bool? extraFitting;
  bool? bikeDecors;
  bool? evVehicleRepairs;
  bool? tankWork;
  bool? denting;
  bool? customization;
  bool? lateWorks;
  bool? secondHandDelay;

  VendorWorksDTO({
    this.id,
    this.electricWork = false,
    this.spares = false,
    this.painting = false,
    this.washing  = false,
    this.puncture  = false,
    this.radiumWork  = false,
    this.seatCover  = false,
    this.meterRepair  = false,
    this.alignment  = false,
    this.chasiAlignment  = false,
    this.welding  = false,
    this.shockAbsorberRepair  = false,
    this.towing  = false,
    this.pickUpAndDrop  = false,
    this.authorisedServicePoint  = false,
    this.forkthTowing  = false,
    this.extraFitting  = false,
    this.bikeDecors  = false,
    this.evVehicleRepairs  = false,
    this.tankWork  = false,
    this.denting  = false,
    this.customization  = false,
    this.lateWorks  = false,
    this.secondHandDelay  = false,
  });

  Map toJson() => {
    "id": id,
    "electicWork": electricWork,
    "painting": painting,
    "spares": spares,
    "washing": washing,
    "puncture": puncture,
    "radiumWork": radiumWork,
    "seatCover": seatCover,
    "meterRepair": meterRepair,
    "alignment": alignment,
    "chasiAlignment": chasiAlignment,
    "welding": welding,
    "shockAbsorberRepair": shockAbsorberRepair,
    "towing": towing,
    "pickUpAndDrop": pickUpAndDrop,
    "authorisedServicePoint": authorisedServicePoint,
    "forkthTowing": forkthTowing,
    "extraFitting": extraFitting,
    "bikeDecors": bikeDecors,
    "evVehicleRepairs": evVehicleRepairs,
    "tankWork": tankWork,
    "denting": denting,
    "customization": customization,
    "lateWorks": lateWorks,
    "secondHandDelay": secondHandDelay
  };

  factory VendorWorksDTO.fromJson(Map<String, dynamic> json) {
    return VendorWorksDTO(
        id: json["id"],
        electricWork: json["electricWork"],
        painting: json["painting"],
        spares: json["spares"],
        washing: json["washing"],
        puncture: json["puncture"],
        radiumWork: json["radiumWork"],
        seatCover: json["seatCover"],
        meterRepair: json["meterRepair"],
        alignment: json["alignment"],
        chasiAlignment: json["chasiAlignment"],
        welding: json["welding"],
        shockAbsorberRepair: json["shockAbsorberRepair"],
        towing: json["towing"],
        pickUpAndDrop: json["pickAndDrop"],
        authorisedServicePoint: json["authorizedServicePoint"],
        forkthTowing: json["forkthTowing"],
        extraFitting: json["extraFitting"],
        bikeDecors: json["bikeDecors"],
        evVehicleRepairs: json["evVehicleRepairs"],
        tankWork: json["tankWork"],
        denting: json["denting"],
        customization: json["customization"],
        lateWorks: json["lateWorks"],
        secondHandDelay: json["secondHandDelay"]
    );
  }

}