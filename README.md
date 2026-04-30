
# witness-sbom-pipeline

A pipeline that generates an SBOM from a software project using Witness attestations and SBOMit.

## Pipeline Flow

```
Target Project (in-toto)
        ↓
Witness run (build step)
        ↓
attestation.json (Witness Attestation)
        ↓
SBOMit generate
        ↓
sbom.json (SBOM - SPDX 2.3)
```

## Environment

| Tool    | Version |
|---------|---------|
| Go      | 1.22.2  |
| Witness | v0.5.2  |
| SBOMit  | 0.0.1   |
| Python  | 3.10.12 |


## References

- [Witness](https://github.com/in-toto/witness)
- [SBOMit](https://github.com/SBOMit/sbomit)
- [in-toto](https://github.com/in-toto/in-toto)
