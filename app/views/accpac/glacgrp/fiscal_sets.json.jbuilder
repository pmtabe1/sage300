json.array! @fiscal_sets.each do |r|
  json.ACCTGRPCOD r.ACCTGRPCOD
  json.ACCTGRPDES r.ACCTGRPDES
  json.GRPCOD account_groups_description(r.GRPCOD)
  json.ACCTID r.ACCTID
  json.ACCTDESC r.ACCTDESC
  json.ACCTTYPE r.ACCTTYPE
  json.ACTIVESW r.ACTIVESW
  json.FSCSYR r.FSCSYR
  json.OPENBAL r.OPENBAL.to_f
  json.NETPERD1 r.NETPERD1.to_f
  json.NETPERD2 r.NETPERD2.to_f
  json.NETPERD3 r.NETPERD3.to_f
  json.NETPERD4 r.NETPERD4.to_f
  json.NETPERD5 r.NETPERD5.to_f
  json.NETPERD6 r.NETPERD6.to_f
  json.NETPERD7 r.NETPERD7.to_f
  json.NETPERD8 r.NETPERD8.to_f
  json.NETPERD9 r.NETPERD9.to_f
  json.NETPERD10 r.NETPERD10.to_f
  json.NETPERD11 r.NETPERD11.to_f
  json.NETPERD12 r.NETPERD12.to_f
  json.CURNTYPE r.CURNTYPE
end
