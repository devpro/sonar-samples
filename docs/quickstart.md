# Quickstart

Runs the Node.js sample end to end, with Docker, Task and Node.js 22 installed.

1. Raise the kernel limit SonarQube needs, once per boot:

   ```bash
   sudo sysctl -w vm.max_map_count=524288
   ```

2. Start SonarQube and get a token:

   ```bash
   export SONAR_TOKEN=$(task bootstrap)
   ```

3. Build, test and scan:

   ```bash
   task build:nodejs
   task scan:nodejs
   ```

4. Open <http://localhost:9000/dashboard?id=sonar-samples-nodejs>, login `admin` / `SonarSamples2026!`.

5. Check the analysis landed with coverage and the expected rules:

   ```bash
   task assert
   ```

6. Stop with `task down`, keeping data, or wipe everything with `task reset`.
   `task logs` and `task status` show the containers.

Any other sample follows the same steps with `build:<sample>` and `scan:<sample>`, see `task --list-all`.
