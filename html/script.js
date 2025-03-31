let jobs = [];

window.addEventListener("message", function () {
  const data = event.data;

  switch (data.action) {
    case "openMenu":
      document.body.style.display = "block";
      break;

    case "updatePlayerInfo":
      updatePlayerInfo(data.playerInfo);
      break;

    case "updateJobs":
      jobs = data.jobs;
      displayJobs();
      break;
  }
});

function Close() {
  document.body.style.display = "none";
  fetch(`https://${GetParentResourceName()}/closeMenu`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({}),
  });
}

function displayJobs() {
  const jobsList = document.getElementById("jobs-list");
  jobsList.innerHTML = "";

  jobs.forEach((job) => {
    const jobCard = document.createElement("div");
    jobCard.className = "job-card";
    jobCard.innerHTML = `
            <i class="${job.icon}"></i>
            <h3>${job.label}</h3>
            <p>${job.description}</p>
            <p class="salary">Salary: $${job.salary}</p>
        `;

    jobCard.addEventListener("click", () => selectJob(job.name));
    jobsList.appendChild(jobCard);
  });
}

function selectJob(jobName) {
  fetch(`https://${GetParentResourceName()}/selectJob`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      jobName: jobName,
    }),
  });

  Close();
}

function updatePlayerInfo(info) {
  document.getElementById("player-name").textContent = info.name;
  document.getElementById("player-money").textContent = `$${info.money}`;
  document.getElementById("player-job").textContent = info.job;
}

document.addEventListener("keyup", function (event) {
  if (event.key === "Escape") {
    Close();
  }
});
