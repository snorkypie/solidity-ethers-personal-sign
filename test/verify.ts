import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Verify", function () {
  async function deploy() {
    const [owner] = await ethers.getSigners();

    const Verify = await ethers.getContractFactory("Verify");
    const verify = await Verify.deploy();

    return { verify, owner };
  }

  it("it can verify signature", async function () {
    const { verify, owner } = await loadFixture(deploy);

    const origMsg = "i like coffee";
    const msg = ethers.utils.solidityKeccak256(["string"], [origMsg]);

    const sig = await ethers.provider.send("personal_sign", [
      msg,
      owner.address,
    ]);

    expect(await verify.verify(origMsg, sig)).to.equal(owner.address);
  });
});
