class Country {
  String countryCode;
  String name;
  String countryFlag ;

  Country(this.countryCode, this.name,this.countryFlag);

  static List<Country> getCountries() {
    return <Country>[
      Country('SYP', 'Syria','sy'),
      Country('LBP', 'lebanon','lb'),
      Country('EGP', 'Egypt','eg'),
      Country('JOD', 'Jordan','jo'),
      Country('SAR', 'Saudi Arabia','sa'),
      Country('KWD', 'Kuwait','kw'),
      Country('AED', 'Emirate','ae'),
      Country('IQD', 'Iraq','iq'),

    ];
  }
}
