# atlas-charts-apps

Umbrella Helm charts (same role as a `helm-applications` repo).

| Chart | Subcharts |
|-------|-----------|
| `atlas-shop` | `catalog-api` (alias of `java-api` from atlas-charts-common) |

`java-api` is vendored under `charts/atlas-shop/charts/` so Argo can render from this Git repo alone.

Copy updates from `atlas-charts-common` when the workload chart changes:

```bash
rm -rf charts/atlas-shop/charts/java-api charts/atlas-shop/charts/_common
cp -R ../atlas-charts-common/charts/java-api charts/atlas-shop/charts/java-api
cp -R ../atlas-charts-common/charts/_common charts/atlas-shop/charts/_common
```
