# DevOps Setup Scripts & Configuration Collection

This repository is a collection of setup scripts and configuration artifacts for experimenting with DevOps, cloud-native, CI/CD, monitoring, security, and application-server tools.

It is **not a single end-to-end installer**. The files are independent examples collected over time; their exact prerequisites and behavior depend on their contents and the operating-system versions they target.

## Inventory

The groupings below are based on file names. Read each file before deciding whether it belongs in your environment.

### Containers, Kubernetes, and infrastructure

| File | Likely topic indicated by the filename |
|---|---|
| [ubuntu-docker.sh](ubuntu-docker.sh) | Docker setup on Ubuntu |
| [docker-compose.sh](docker-compose.sh) | Docker Compose setup |
| [ubuntu-minikube.sh](ubuntu-minikube.sh) | Minikube setup on Ubuntu |
| [ubuntu-kops.sh](ubuntu-kops.sh) / [kops.sh](kops.sh) | Kubernetes cluster setup with kops |
| [metric-server.sh](metric-server.sh) | Kubernetes Metrics Server |
| [helm.sh](helm.sh) | Helm setup |
| [argocd.sh](argocd.sh) / [argocd](argocd) | Argo CD-related setup or configuration |
| [terraform.sh](terraform.sh) / [terrform-ubuntu](terrform-ubuntu) / [terraformer](terraformer) | Terraform-related tooling |

### CI/CD, registries, and application servers

| File | Likely topic indicated by the filename |
|---|---|
| [jenkins.sh](jenkins.sh) / [ubuntu-jenkins.sh](ubuntu-jenkins.sh) | Jenkins setup |
| [nexus.sh](nexus.sh) | Nexus repository manager |
| [jfrog.sh](jfrog.sh) | JFrog tooling |
| [tomcat.sh](tomcat.sh), [tomcat-ubuntu](tomcat-ubuntu), [tomcat.yml](tomcat.yml) | Apache Tomcat setup/configuration |
| [tomcat-users.xml](tomcat-users.xml) | Tomcat user configuration example |

### Monitoring, logging, and security

| File | Likely topic indicated by the filename |
|---|---|
| [prometheus.sh](prometheus.sh) | Prometheus setup |
| [grafana.sh](grafana.sh) | Grafana setup |
| [nodeexporter.sh](nodeexporter.sh) | Prometheus Node Exporter |
| [nagioscore.sh](nagioscore.sh) / [nagiosplugin.sh](nagiosplugin.sh) | Nagios Core and plugin setup |
| [loki & promtail](loki%20%26%20promtail) | Loki / Promtail artifacts |
| [trivy](trivy) / [TRIVY.txt](TRIVY.txt) | Trivy-related artifacts or notes |
| [sonar.sh](sonar.sh) | SonarQube setup |

### Databases, networking, and other examples

| File | Likely topic indicated by the filename |
|---|---|
| [mysql.sh](mysql.sh) | MySQL setup |
| [arango.sh](arango.sh) | ArangoDB setup |
| [nginx-ip-block](nginx-ip-block) | NGINX IP-blocking configuration/example |
| [pegion.sh](pegion.sh), [pegion-ubuntu.sh](pegion-ubuntu.sh) | File-name indicates a setup script; inspect contents to identify its exact purpose |
| [kubecolor](kubecolor) | File or artifact related to kubecolor |
| [context.xml](context.xml) | Application-server configuration artifact |

The repository also contains [netflix.sh](netflix.sh), [netflix.yml](netflix.yml), [swiggy.sh](swiggy.sh), and [mini-al.sh](mini-al.sh). Inspect those files to understand their purpose and dependencies; their names alone do not establish what they deploy.

## Safe way to use a script

1. **Inspect first.** Read the full script and any referenced configuration before running it.
2. **Check assumptions.** Confirm the supported OS/version, package sources, service names, ports, users, and expected credentials.
3. **Understand its changes.** Look for `sudo`, package installs, repository/key changes, firewall changes, service restarts, downloads, and destructive commands.
4. **Test in a disposable environment.** Prefer a local virtual machine or lab rather than a personal workstation, shared host, or production machine.
5. **Validate the result.** Check the installed tool version, service status, listening ports, and logs.
6. **Document the outcome.** Record prerequisites, commands, expected output, known limitations, and cleanup steps.

Example read-only inspection commands on Linux:

```bash
sed -n '1,240p' ./prometheus.sh
grep -nE 'sudo|curl|wget|apt|yum|dnf|systemctl|iptables|rm -rf|password|token|secret' ./prometheus.sh
```

These commands help inspect a script; they do not prove that the script is safe. Review all referenced files and downloaded content as well.

## Security notes

- Do not run every script as a batch.
- Do not pipe remote downloads directly into a shell without reviewing the content and source.
- Never commit real passwords, access tokens, cloud keys, SSH private keys, or production configuration.
- Replace demo credentials and open ports before any shared-environment use.
- Do not apply examples to company or production systems without authorization and a reviewed change plan.
- Treat this repository as a collection of examples, not as verified or production-ready installation procedures.

## Current limitations

This repository does not currently document a common test harness or guarantee that every script has been tested on a current operating-system release. Validate each file independently before use. Where a reliable test result or screenshot exists, add it alongside the corresponding script.
