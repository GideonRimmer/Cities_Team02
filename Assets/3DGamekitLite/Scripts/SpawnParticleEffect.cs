using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnParticleEffect : MonoBehaviour
{
    public ParticleSystem particleEffect;
    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("Spawn particle effect");
        Instantiate(particleEffect, this.transform.position, Quaternion.identity);
    }
}
